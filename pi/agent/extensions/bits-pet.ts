import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

// Thin pi wrapper for the Bits Pet desktop app.
//
// Installed under ~/.pi/agent/extensions/bits-pet.ts so pi auto-discovers it.
// Existing sessions should run /reload (or be restarted) after install.
//
// Maps pi's lifecycle and permission prompt seams to the app's local HTTP
// control server:
//   input     -> /wake   (quiet perk-up when you send a message)
//   agent_end -> /bark   (loud bark when pi finishes / needs you)
//   permission prompt -> /bark (loud bark when a permission UI appears)
//
// Permission-prompt barking is best-effort and intentionally does not replace
// pi's own permission UI. It listens for the @gotgenes/pi-permission-system
// event bus signal, and also wraps the shared ctx.ui.confirm/select methods so
// frameworks without an event still make Bits bark when they ask for input.
//
// Requests are fire-and-forget with short timeouts. If the app is not running,
// failures are ignored so the pet never slows or breaks pi.

const BASE = "http://127.0.0.1:4242";
const PATCHED = Symbol.for("bits-pet:ui-patched");

function poke(path: "bark" | "wake", source?: string): void {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 1000);
  const suffix = source ? `?source=${encodeURIComponent(source)}` : "";
  fetch(`${BASE}/${path}${suffix}`, { signal: controller.signal })
    .catch(function ignorePetUnavailable() {
      /* pet may simply not be running */
    })
    .finally(function clearPokeTimeout() {
      clearTimeout(timeout);
    });
}

// Coalesce barks so a single "needs you" moment cannot double-fire through both
// the permission event bus and the UI fallback wrapper.
let lastBark = 0;
function bark(source: string): void {
  const now = Date.now();
  if (now - lastBark < 750) return;
  lastBark = now;
  poke("bark", source);
}

function patchPermissionUI(ctx: ExtensionContext): void {
  if (!ctx.hasUI) return;

  let ui: Record<string | symbol, unknown>;
  try {
    ui = ctx.ui as unknown as Record<string | symbol, unknown>;
  } catch {
    return;
  }

  if (!ui || ui[PATCHED]) return;

  for (const method of ["confirm", "select"] as const) {
    const original = ui[method];
    if (typeof original !== "function") continue;
    const wrapped = (original as (...args: unknown[]) => unknown).bind(ui);
    ui[method] = function bitsPetPermissionPromptWrapper(...args: unknown[]) {
      bark("pi permission prompt");
      return wrapped(...args);
    };
  }

  ui[PATCHED] = true;
}

async function handleInput(event: { source?: string }): Promise<{ action: "continue" }> {
  if (event.source !== "extension") poke("wake");
  return { action: "continue" };
}

async function handleAgentEnd(): Promise<void> {
  bark("pi agent finished");
}

async function handleSessionStart(_event: unknown, ctx: ExtensionContext): Promise<void> {
  patchPermissionUI(ctx);
}

function handlePermissionPrompt(raw: unknown): void {
  const event = (raw ?? {}) as { value?: unknown; message?: unknown };
  if (typeof event.value === "string" || typeof event.message === "string") {
    bark("pi permission prompt");
  }
}

async function handleBitsBarkCommand(
  _args: unknown,
  ctx: ExtensionContext,
): Promise<void> {
  bark("pi test bark");
  ctx.ui.notify("🐶 woof", "info");
}

export default function bitsPetExtension(pi: ExtensionAPI) {
  pi.on("input", handleInput);
  pi.on("agent_end", handleAgentEnd);
  pi.on("session_start", handleSessionStart);
  pi.events.on("permissions:ui_prompt", handlePermissionPrompt);

  pi.registerCommand("bits-bark", {
    description: "Make the Bits desktop pet bark (test the wiring).",
    handler: handleBitsBarkCommand,
  });
}

/**
 * session-cost-prompt extension
 *
 * Injects the current running session cost into the system prompt before each
 * agent run, so the model can see how much the session has cost so far.
 *
 * The cost is the same running total pi's footer shows: assistant responses,
 * tool calls that report usage, and compaction/branch-summary generation. It
 * excludes the current (not-yet-completed) turn.
 *
 * Enable/disable with `/prompt-cost`. Enabled by default, or edit `enabled` below.
 *
 * NOTE: `/prompt-cost` is deliberately distinct from the installed
 * `pi-session-cost` package's `/session-cost` command (footer status + cost
 * lookup). Registering the same command name twice makes pi rename both to
 * `/session-cost:1` / `/session-cost:2`, which silently breaks plain
 * `/session-cost`.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	let enabled = true;

	/** Sum session cost the same way pi's footer does. */
	function sessionCost(ctx: any): number {
		let total = 0;
		for (const entry of ctx.sessionManager.getBranch()) {
			let usage: any;
			if (entry.type === "message") {
				usage = entry.message?.usage;
			} else if (entry.type === "compaction" || entry.type === "branch_summary") {
				usage = entry.usage;
			}
			if (usage?.cost?.total) total += usage.cost.total;
		}
		return total;
	}

	function fmtCost(cost: number): string {
		if (cost >= 100) return `$${cost.toFixed(2)}`;
		if (cost >= 1) return `$${cost.toFixed(3)}`;
		return `$${cost.toFixed(4)}`;
	}

	pi.registerCommand("prompt-cost", {
		description: "Toggle session cost injection into the system prompt",
		handler: async (_args, ctx) => {
			enabled = !enabled;
			const cost = sessionCost(ctx);
			ctx.ui.notify(
				enabled
					? `Session cost will be sent in the prompt (current: ${fmtCost(cost)})`
					: "Session cost removed from the prompt",
				"info",
			);
		},
	});

	pi.on("before_agent_start", async (event, ctx) => {
		if (!enabled) return;
		const note = `[Session cost so far: ${fmtCost(sessionCost(ctx))} — running total, does not include the current turn]`;
		return { systemPrompt: event.systemPrompt + "\n\n" + note };
	});
}

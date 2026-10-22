#!/usr/bin/env bash
# Makes Bits bark (loud) when an agent finishes a task or needs attention.
# Fails silently if the pet isn't running, so it never blocks your agent.
set -euo pipefail

EVENT_NAME="$(python3 -c 'import json,sys
try:
    data=json.load(sys.stdin)
    print(data.get("hook_event_name") or data.get("event") or "Claude Code")
except Exception:
    print("Claude Code")
' 2>/dev/null || printf 'Claude Code')"

case "$EVENT_NAME" in
  Stop) SOURCE="Claude Code finished" ;;
  Notification) SOURCE="Claude Code notification" ;;
  *) SOURCE="$EVENT_NAME" ;;
esac

python3 - "$SOURCE" <<'PY' | xargs -I{} curl --silent --max-time 1 'http://127.0.0.1:4242/bark?source={}' >/dev/null 2>&1 || true
import sys, urllib.parse
print(urllib.parse.quote(sys.argv[1], safe=''))
PY

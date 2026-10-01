#!/usr/bin/env bash
# tail-ot-logs.sh — tail OT protocol logs from Malcolm's Zeek output
#
# Usage: bash scripts/tail-ot-logs.sh
#
# Requires MALCOLM_DIR to point to the Malcolm checkout, or defaults to
# the directory two levels above this script.
# Requires tail and jq (apt install jq).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MALCOLM_DIR="${MALCOLM_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
ZEEK_LOG_DIR="$MALCOLM_DIR/zeek-logs/current"

if [[ ! -d "$ZEEK_LOG_DIR" ]]; then
    echo "error: Zeek log directory not found: $ZEEK_LOG_DIR" >&2
    echo "  Is Malcolm running? Set MALCOLM_DIR to the Malcolm checkout root." >&2
    exit 1
fi

OT_LOGS=(
    "$ZEEK_LOG_DIR/modbus.log"
    "$ZEEK_LOG_DIR/dnp3.log"
    "$ZEEK_LOG_DIR/enip.log"
    "$ZEEK_LOG_DIR/bacnet.log"
    "$ZEEK_LOG_DIR/s7comm.log"
)

EXISTING=()
for log in "${OT_LOGS[@]}"; do
    [[ -f "$log" ]] && EXISTING+=("$log")
done

if [[ ${#EXISTING[@]} -eq 0 ]]; then
    echo "no OT protocol logs found yet in $ZEEK_LOG_DIR"
    echo "waiting for traffic..."
fi

echo "tailing OT logs (ctrl-c to stop):"
printf '  %s\n' "${EXISTING[@]:-none yet}"
echo

if command -v jq &>/dev/null; then
    tail -F "${OT_LOGS[@]}" 2>/dev/null | jq -c '.' 2>/dev/null || tail -F "${OT_LOGS[@]}" 2>/dev/null
else
    tail -F "${OT_LOGS[@]}" 2>/dev/null
fi

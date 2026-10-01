#!/usr/bin/env bash
# ingest-pcap.sh — copy a PCAP file into Malcolm's upload directory
#
# Usage: bash scripts/ingest-pcap.sh /path/to/capture.pcap
#
# Requires MALCOLM_DIR to point to the Malcolm checkout, or defaults to
# the directory two levels above this script.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MALCOLM_DIR="${MALCOLM_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
UPLOAD_DIR="$MALCOLM_DIR/pcap/upload"

if [[ $# -lt 1 ]]; then
    echo "usage: $0 /path/to/capture.pcap" >&2
    exit 1
fi

PCAP="$1"

if [[ ! -f "$PCAP" ]]; then
    echo "error: file not found: $PCAP" >&2
    exit 1
fi

if [[ ! -d "$UPLOAD_DIR" ]]; then
    echo "error: Malcolm upload directory not found: $UPLOAD_DIR" >&2
    echo "  Set MALCOLM_DIR to the Malcolm checkout root." >&2
    exit 1
fi

BASENAME="$(basename "$PCAP")"
cp "$PCAP" "$UPLOAD_DIR/$BASENAME"
echo "ingesting: $BASENAME -> $UPLOAD_DIR"
echo "Malcolm will process this file automatically."
echo "Check progress at https://localhost (OpenSearch Dashboards -> Discover)"

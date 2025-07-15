#!/bin/bash

# Configuration
# TARGET_WS_SERVICE should be a ws:// or wss:// URL (e.g., ws://your-websocket-app.your-project.svc.cluster.local/ws)
TARGET_WS_SERVICE=${TARGET_WS_SERVICE:-"ws://localhost:8080/ws"}
INTERVAL=${INTERVAL:-5} # seconds
TIMEOUT=${TIMEOUT:-10} # seconds for each probe attempt

echo "Starting WebSocket probe for service: $TARGET_WS_SERVICE every $INTERVAL seconds..."

while true; do
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "-----------------------------------"
    echo "Probing $TARGET_WS_SERVICE at $TIMESTAMP"

    # Use websocat to attempt a connection and immediately close it or send a simple message
    # --ping-interval: Send a WebSocket ping frame every X seconds (useful for keeping connection alive or checking liveness)
    # --close-timeout: How long to wait after sending a close frame for the remote side to respond
    # --exit-on-eof: Exit if the input (stdin) is closed
    # --connect-timeout: Timeout for the TCP connection
    # --dump-header: Dump handshake response headers (for debugging)
    # If you want to send a specific message and wait for a response:
    # echo "ping" | websocat --ws-url "$TARGET_WS_SERVICE" --connect-timeout "$TIMEOUT" --close-timeout 1 --no-close --exit-on-eof -t 'received_message_timeout=5'

    # Simple connection test: Attempt to connect and immediately close.
    # We rely on the exit code of websocat.
    websocat --ws-url "$TARGET_WS_SERVICE" --connect-timeout "$TIMEOUT" --close-timeout 1 --no-close --exit-on-eof --max-messages 1 > /dev/null 2>&1
    WS_STATUS=$?

    if [ $WS_STATUS -eq 0 ]; then
        echo "WebSocket connection to $TARGET_WS_SERVICE successful!"
    else
        echo "WebSocket connection to $TARGET_WS_SERVICE failed with exit code: $WS_STATUS"
        # For more verbose error output from websocat, you might remove > /dev/null 2>&1 during debugging.
    fi

    echo "-----------------------------------"
    sleep $INTERVAL
done
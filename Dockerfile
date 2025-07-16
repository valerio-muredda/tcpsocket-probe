# Use a base image that websocat supports, e.g., Alpine
FROM alpine:latest

# Install websocat
# Check websocat's GitHub releases for the latest pre-compiled binary for musl (Alpine)
# Example: https://github.com/vi/websocat/releases
RUN apk add --no-cache curl \
    && curl -LO https://github.com/vi/websocat/releases/download/v1.12.0/websocat.x86_64-unknown-linux-musl \
    && chmod +x websocat.x86_64-unknown-linux-musl \
    && mv websocat.x86_64-unknown-linux-musl /usr/local/bin/websocat

# Copy the probe script into the container
COPY websocket_probe.sh /usr/local/bin/websocket_probe.sh

# Make the script executable
RUN chmod +x /usr/local/bin/websocket_probe.sh

# Set default command to run the probe script
#CMD ["/usr/local/bin/websocket_probe.sh"]
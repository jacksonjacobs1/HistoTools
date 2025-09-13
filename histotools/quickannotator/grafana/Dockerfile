FROM grafana/grafana:main-ubuntu

USER root

# Install curl
RUN apt update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy dashboard JSON file into the image
COPY dashboard.json /tmp/dashboard.json

# Script to add dashboard via Grafana API
COPY add_dashboard.sh /add_dashboard.sh
RUN chmod +x /add_dashboard.sh

# Start Grafana and add dashboard
CMD /add_dashboard.sh /tmp/dashboard.json && \
    wait
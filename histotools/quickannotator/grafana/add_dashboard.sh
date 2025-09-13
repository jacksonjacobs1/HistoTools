#!/bin/bash

GRAFANA_URL="localhost:3000"
DASHBOARD_JSON_FILE="$1"

if [[ -z "$GRAFANA_URL" || -z "$DASHBOARD_JSON_FILE" ]]; then
    echo "Usage: $0 <dashboard_json_file>"
    exit 1
fi

POSTGIS_DATASOURCE_JSON='{
    "name": "PostGIS",
    "type": "postgres",
    "access": "proxy",
    "url": "localhost:5432",
    "database": "qa_postgis_db",
    "user": "admin",
    "password": "admin",
    "jsonData": {
        "sslmode": "disable"
    }
}'

echo "$POSTGIS_DATASOURCE_JSON" > /tmp/postgis_datasource.json

# Wait for Grafana to be ready
until curl -s -u "admin:admin" "$GRAFANA_URL/api/health" | grep -q '"database":true'; do
  echo "Waiting for Grafana to be ready..."
  sleep 5
done

echo "Grafana is ready. Adding dashboard..."

curl -X POST "$GRAFANA_URL/api/datasources" \
        -H "Content-Type: application/json" \
        -u admin:admin \
        --data-binary @/tmp/postgis_datasource.json


NAMESPACE="default"  # Change this to your desired namespace

curl -X POST "$GRAFANA_URL/apis/dashboard.grafana.app/v1beta1/namespaces/$NAMESPACE/dashboards" \
    -H "Content-Type: application/json" \
    -u admin:admin \
    --data-binary @"$DASHBOARD_JSON_FILE"



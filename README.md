## Project notes

Individual run command for docker compose:
```bash
docker compose -f histotools/quickannotator/docker-compose.yaml up -d
```

Main run command for ray cluster (includes docker compose call):
```bash
ray up local_cluster_config.yaml -v --no-config-cache
```
# docker-radicale

docker:
```
docker run -it --rm -e PUID=radicale -e PGID=radicale -e TZ=America/New_York -p 5232:5232 \
    -v ${PWD}/radicale:/etc/radicale -v ${PWD}/DecSync:/srv/radicale/decsync ghcr.io/jceloria/radicale
```

docker-compose.yaml:
```
---
services:
  radicale:
    container_name: radicale
    environment:
      - PUID=radicale
      - PGID=radicale
      - TZ=America/New_York
    healthcheck:
      interval: 30s
      retries: 3
      start_period: 40s
      test:
        - CMD-SHELL
        - curl --fail http://radicale:5232 || exit 1
      timeout: 10s
    image: ghcr.io/jceloria/radicale
    logging:
      driver: json-file
      options:
        max-size: 5m
    ports:
      - 5232:5232
    restart: unless-stopped
    volumes:
      - ${PWD}/radicale:/etc/radicale
      - ${PWD}/DecSync:/srv/radicale/decsync
```

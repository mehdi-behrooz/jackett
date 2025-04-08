# Jackett

## How to use

```yml
services:
  jackett:
    image: ghcr.io/mehdi-behrooz/jackett:latest
    container_name: test-jackett
    volumes:
      - jackett-storage:/config/
    environment:
      - ADMIN_PASSWORD=${ADMIN_PASSWORD}
      - API_KEY=${API_KEY} #optional
      - INDEXERS=eztv, therarbg, yts
    ports:
      - 9117:9117

volumes:
  jacket-storage:
```

You can use this command to generate an API key:

```bash
head /dev/urandom | tr -dc a-z0-9 | head -c 32
```

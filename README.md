# Traefik V3

[Traefik](https://traefik.io/) is a modern reverse proxy and load balancer that makes deploying microservices easy. This project provides a complete Traefik v3 setup with SSL certificate management and [Sablier](https://sablier.app/) integration for on-demand container management.

**Version:** Traefik v3.6

## Features

- 🚀 **Traefik v3.6** - Latest Traefik reverse proxy with Docker provider
- 🔒 **SSL/TLS Support** - Wildcard certificates for `*.local.io` domains using mkcert
- ⚡ **Sablier Integration** - On-demand container startup with dynamic waiting pages
- 📊 **Dashboard** - Web UI for monitoring and managing routes
- 🐳 **Docker Compose** - Easy deployment and management
- 🔧 **Makefile** - Convenient commands for common operations

## Requirements

- **Docker** - Container runtime
- **Docker Compose** - Multi-container orchestration
- **Make** - Build automation tool
- **mkcert** - For generating local SSL certificates (install via `brew install mkcert` on macOS)

## Quick Start

### 1. Generate SSL Certificates

First, generate wildcard SSL certificates for local development:

```bash
make certs
```

This creates certificates for `*.local.io` and `local.io` domains in `docker/certs/`.

### 2. Add Local Hosts (Optional)

Add local domain entries to `/etc/hosts`:

```bash
make add_localhost
```

This adds:
- `traefik.local.io` / `dashboard.local.io` → Traefik dashboard

To remove these entries later:
```bash
make remove_localhost
```

### 3. Start Services

Start Traefik and Sablier:

```bash
make start
```

### 4. Access the Dashboard

- **Traefik Dashboard:** http://127.0.0.1:8081/ or https://dashboard.local.io

> **Note:** Sablier runs as a backend service for the Traefik plugin and is not exposed via a web UI.

## Available Commands

Run `make help` to see all available commands:

| Command | Description |
|---------|-------------|
| `make start` | Start Traefik and Sablier containers |
| `make stop` | Stop all running containers |
| `make certs` | Generate wildcard SSL certificates for `*.local.io` |
| `make add_localhost` | Add local domains to `/etc/hosts` |
| `make remove_localhost` | Remove local domains from `/etc/hosts` |
| `make whoami` | Start a test container for validation |
| `make install` | Install the project as an executable |
| `make remove` | Remove the installed executable |
| `make help` | Show all available commands |

## Project Structure

```
.
├── docker/
│   ├── certs/                    # SSL certificates (generated)
│   ├── config/
│   │   ├── sablier/              # Sablier configuration
│   │   │   ├── sablier.yml
│   │   │   └── themes/
│   │   └── traefik/              # Traefik configuration
│   │       ├── traefik.yml       # Main Traefik config
│   │       └── dynamic.yml       # Dynamic config (middlewares, TLS)
│   ├── docker-compose.yml        # Main compose file
│   └── docker-compose-test.yml   # Test container compose file
├── scripts/
│   ├── generate-cert.sh          # SSL certificate generation script
│   └── run.sh                    # Executable wrapper script
├── Makefile                      # Build automation
└── README.md                     # This file
```

## Configuration

### Traefik Configuration

- **Main Config:** `docker/config/traefik/traefik.yml`
  - Entrypoints: `web` (80), `websecure` (443), `db` (90), `ssh` (22)
  - Docker provider enabled on `lb-common` network
  - API dashboard enabled on port 8080

- **Dynamic Config:** `docker/config/traefik/dynamic.yml`
  - HTTPS redirect middleware
  - Sablier plugin configuration
  - TLS certificate settings

### Sablier Configuration

Sablier is configured to manage containers on-demand:
- **Group:** `traefik`
- **Session Duration:** 5 minutes
- **Strategy:** Dynamic (shows waiting page)
- **Theme:** Ghost

### Ports

| Port | Service | Description |
|------|---------|-------------|
| 80 | HTTP | Standard HTTP port |
| 443 | HTTPS | Standard HTTPS port |
| 8080 | HTTP (alt) | Alternative HTTP port |
| 8443 | HTTPS (alt) | Alternative HTTPS port |
| 8081 | Dashboard | Traefik web UI |
| 90 | DB | Database entrypoint |
| 22 | SSH | SSH entrypoint |

## Adding Your Services

To route traffic to your containers through Traefik, add labels to your Docker Compose services:

```yaml
services:
  my-service:
    image: my-image
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.my-service.rule=Host(`my-service.local.io`)"
      - "traefik.http.routers.my-service.entrypoints=websecure"
      - "traefik.http.routers.my-service.tls=true"
      - "traefik.http.services.my-service.loadbalancer.server.port=8080"
    networks:
      - lb-common
```

### Using Sablier Middleware

To enable on-demand startup for your service:

```yaml
services:
  my-service:
    # ... other config ...
    labels:
      - "sablier.enable=true"
      - "sablier.group=traefik"
      - "traefik.http.routers.my-service.middlewares=sablier@file"
```

## Testing

Test your setup with the included `whoami` container:

```bash
make whoami
```

This starts a test container accessible at http://whoami.local.io

## Network

All services run on the `lb-common` Docker network, which is:
- **Name:** `lb-common`
- **Attachable:** `true`
- **Type:** Bridge (default)

Make sure your services are connected to this network to be discovered by Traefik.

## Troubleshooting

### Certificates not working

1. Ensure `mkcert` is installed: `brew install mkcert`
2. Run `make certs` to regenerate certificates
3. Verify certificates exist in `docker/certs/`

### Services not appearing in dashboard

1. Check that services are on the `lb-common` network
2. Verify `traefik.enable=true` label is set
3. Ensure Traefik is running: `docker ps | grep traefik`

### Dashboard not accessible

1. Check if Traefik is running: `make start`
2. Verify port 8081 is not in use
3. Access via http://127.0.0.1:8081/ (insecure mode enabled)

## License

This project is provided as-is for local development purposes.

## Resources

- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Sablier Documentation](https://sablier.app/docs)
- [mkcert Documentation](https://github.com/FiloSottile/mkcert)

## Author

**Martin Raynov**

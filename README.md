# Traefik V3

[Traefik](https://traefik.io/) is a reverse proxy / load balancer container used to route the containers trafic.
You must initialize this container to be able to route the trafic of your containers.

Version used is the v3.3

You can check the containers that are routed via the Traefik application by going to http://127.0.0.1:8081/dashboard/#/

## Requirements

You need to have docker, docker-compose and make installed on your machine to be able to execute the commands

## Start the container

```bash
make start
```

## Stop the container

```bash
make stop
```

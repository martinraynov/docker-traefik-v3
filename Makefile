M = $(shell printf "\033[34;1m▶\033[0m")

.PHONY: help
help: ## Prints this help message
	@grep -E '^[a-zA-Z_-]+:.?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

######################
### MAIN FUNCTIONS ###
######################

.PHONY: start
start: ## Start the Traefik docker container
	$(info $(M) Starting an instance of Traefik at : http://127.0.0.1:8081/)
	@docker-compose -f ./docker/docker-compose.yml up -d

.PHONY: stop
stop: ## Stopping running Traefik instances
	$(info $(M) Stopping Traefik instance)
	@docker-compose -f ./docker/docker-compose.yml down

.PHONY: whoami
whoami: ## Start test container for validation
	$(info $(M) Starting an instance of Test container at : http://whoami.local.io/)
	@docker-compose -f ./docker/docker-compose-test.yml up

.DEFAULT_GOAL := help

M = $(shell printf "\033[34;1m▶\033[0m")
APP_NAME = traefik

.PHONY: help
help: ## Prints this help message
	@grep -E '^[a-zA-Z_-]+:.?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: ## Install Application as executable
	$(info $(M) Installing $(APP_NAME) as executable at /usr/local/bin/$(APP_NAME))
	@sudo ln -s ${PWD}/scripts/run.sh /usr/local/bin/$(APP_NAME)

.PHONY: remove
remove: ## Remove Application as executable
	$(info $(M) Removing $(APP_NAME) as executable from /usr/local/bin/$(APP_NAME))
	@sudo unlink /usr/local/bin/$(APP_NAME)

######################
### MAIN FUNCTIONS ###
######################

.PHONY: start
start: ## Start the Traefik docker container
	$(info $(M) Starting an instance of $(APP_NAME) at : http://127.0.0.1:8081/)
	@docker-compose -f ./docker/docker-compose.yml up -d

.PHONY: stop
stop: ## Stopping running Traefik instances
	$(info $(M) Stopping $(APP_NAME) instance)
	@docker-compose -f ./docker/docker-compose.yml down

.PHONY: whoami
whoami: ## Start test container for validation
	$(info $(M) Starting an instance of Test container at : http://whoami.local.io/)
	@docker-compose -f ./docker/docker-compose-test.yml up


.DEFAULT_GOAL := help

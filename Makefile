.PHONY: help deploy deploy.ssh deploy.initssl initssl logs run shell start stop

default: help

help: ## Show this help
	@echo "Adam Resume"
	@echo "==========="
	@echo
	@echo "Container for running my resume"
	@echo
	@fgrep -h " ## " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -Ee 's/([a-z.]*):[^#]*##(.*)/\1##\2/' | column -t -s "##"

deploy: ## Deploy the application
	@rsync -av -e ssh --exclude='.git*' --exclude='data/certbot' --delete . root@gschwa:/usr/local/src/gschwa
	@ssh -t root@gschwa "cd /usr/local/src/gschwa; docker-compose up --build -d; docker-compose exec gschwa nginx -s reload"

deploy.ssh: ## SSH to the deploy application server
	@ssh -t root@gschwa "cd /usr/local/src/gschwa; /bin/bash"

deploy.initssl: ## Initialize SSL certs on application server
	@ssh -t root@gschwa "cd /usr/local/src/gschwa; ./init-letsencrypt.sh"

initssl: ## Initialize SSL certs on the local server
	@LOCAL=1 ./init-letsencrypt.sh

logs: ## Show the logs from the application
	@docker-compose logs --follow gschwa

run: ## Run the application locally in interactive mode
	@docker-compose up --build gschwa

shell: ## Create a shell in the application container
	@docker-compose exec gschwa /bin/bash

start: ## Run the application locally in the background
	@docker-compose up --build -d gschwa

stop: ## Stop the application
	@docker-compose down

.PHONY: help build deploy deploy.ssh logs run start stop

default: help

help: ## Show this help
	@echo "Adam Resume"
	@echo "==========="
	@echo
	@echo "Container for running my resume"
	@echo
	@fgrep -h " ## " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -Ee 's/([a-z.]*):[^#]*##(.*)/\1##\2/' | column -t -s "##"

build: ## Build the application
	@docker build -t adam-resume .

deploy: ## Deploy the application
	@rsync -av -e ssh --exclude='.git*' --delete . root@gschwa:/usr/local/src/gschwa
	@ssh -t root@gschwa "cd /usr/local/src/gschwa; docker build -t adam-resume .; (docker stop adam-resume-cntr || true); docker run --name adam-resume-cntr -d -p 80:80 --rm adam-resume"

deploy.ssh: ## SSH to the deploy application server
	@ssh -t root@gschwa "cd /usr/local/src/gschwa; /bin/bash"

logs: ## Show the logs from the application
	@docker logs -f adam-resume-cntr

run: ## Run the application locally in interactive mode
	@docker run --name adam-resume-cntr -i -p 80:80 --rm adam-resume

start: ## Run the application locally in the background
	@docker run --name adam-resume-cntr -d -p 80:80 --rm adam-resume

stop: ## Stop the application
	@docker stop adam-resume-cntr


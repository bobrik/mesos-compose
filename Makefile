YAML2JSON = ( python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' 2>/dev/null || ruby -ryaml -rjson -e 'puts JSON.pretty_generate(YAML.load(ARGF))' )
MARATHON_CURL = curl -s -X PUT -H "Content-type: application/json" -d @-

DOCKER_IP ?= 127.0.0.1
export DOCKER_IP

.docker:
	[ -d .docker ] || mkdir .docker
	cp ~/.docker/config.json ./.docker

docker-login:
	docker login -u="$(DOCKER_USERNAME)" -p="$(DOCKER_PASSWORD)"

.PHONY: prepare
prepare: docker-login .docker
	tar -cvzf ./docker.tar.gz .docker/config.json

.PHONY: run
deploy:
	$(YAML2JSON) < apps/$(APP).yaml | $(MARATHON_CURL) http://dev:8080/v2/groups | jq .

.PHONY: run
run: prepare
	docker-compose up

.PHONY: start
start: prepare
	docker-compose up -d

.PHONY: stop
stop:
	docker-compose stop

.PHONY: destroy
destroy: stop
	docker-compose rm -f --all
	[ -z .docker ] || rm -rf .docker
	[ -z docker.tar.gz ] || rm -rf docker.tar.gz


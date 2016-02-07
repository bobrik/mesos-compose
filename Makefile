YAML2JSON = ( python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' 2>/dev/null || ruby -ryaml -rjson -e 'puts JSON.pretty_generate(YAML.load(ARGF))' )
MARATHON_CURL = curl -s -X PUT -H "Content-type: application/json" -d @-

.PHONY: run
deploy:
	$(YAML2JSON) < apps/$(APP).yaml | $(MARATHON_CURL) http://dev:8080/v2/groups | jq .

.PHONY: run
run:
	docker-compose up

.PHONY: start
start:
	docker-compose up -d

.PHONY: stop
stop:
	docker-compose stop

.PHONY: destroy
destroy: stop
	docker-compose rm -fv

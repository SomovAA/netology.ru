docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-down-clear:
	docker-compose down --volume

ansible-galaxy-install:
	ansible-galaxy install -r ./playbook/requirements.yml -p ./playbook/roles

ansible-galaxy-install-force:
	ansible-galaxy install -r ./playbook/requirements.yml -p ./playbook/roles --force

ansible-playbook:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml

ansible-playbook-check:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml --check

ansible-playbook-diff:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml --diff

ansible-playbook-tags-vector:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml --tags "vector"

ansible-playbook-tags-lighthouse:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml --tags "lighthouse"

ansible-playbook-tags-clickhouse:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml --tags "clickhouse"

ansible-lint:
	ansible-lint ./playbook/site.yml -v
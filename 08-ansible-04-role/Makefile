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

ansible-playbook-tags-install:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml --tags "install"

ansible-lint:
	ansible-lint ./playbook/site.yml

docker-exec-clickhouse-01-check-service:
	docker exec -it clickhouse-01 sh -c 'systemctl status clickhouse-server'

docker-exec-clickhouse-client-check:
	docker exec -it clickhouse-01 sh -c "clickhouse-client -h 127.0.0.1 --port 9000 -q 'show databases'"

docker-exec-vector-01-status-service:
	docker exec -it vector-01 sh -c 'systemctl status vector'
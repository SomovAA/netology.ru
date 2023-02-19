docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-down-clear:
	docker-compose down --volume

docker-exec-clickhouse-01-check-service:
	docker exec -it clickhouse-01 sh -c 'systemctl status clickhouse-server'

docker-exec-clickhouse-client-check:
	docker exec -it clickhouse-01 sh -c 'clickhouse-client -h 127.0.0.1'

docker-exec-vector-01-status-service:
	docker exec -it vector-01 sh -c 'systemctl status vector'

ansible-playbook:
	ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml

ansible-lint:
	ansible-lint ./playbook/site.yml -v

ansible-playbook-check:
	ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --check

ansible-playbook-diff:
	ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --diff

ansible-playbook-tags-vector:
	ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --tags "vector"
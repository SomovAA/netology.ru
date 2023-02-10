docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-down-clear:
	docker-compose down --volume

docker-exec-clickhouse-01:
	docker exec -it clickhouse-01 ls

docker-exec-vector-01:
	docker exec -it vector-01 ls

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
docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-down-clear:
	docker-compose down --volume

ansible-playbook-test:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml

ansible-lint:
	ansible-lint ./playbook/site.yml -v
docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-down-clear:
	docker-compose down --volume

ansible-playbook-test:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml

ansible-playbook-test-check:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml --check

ansible-playbook-test-diff:
	ansible-playbook -i ./playbook/inventory/test ./playbook/site.yml --diff

ansible-playbook-prod:
	ansible-playbook -i ./playbook/inventory/prod ./playbook/site.yml

ansible-playbook-prod-check:
	ansible-playbook -i ./playbook/inventory/prod ./playbook/site.yml --check

ansible-playbook-prod-diff:
	ansible-playbook -i ./playbook/inventory/prod ./playbook/site.yml --diff

ansible-lint:
	ansible-lint ./playbook/site.yml -v
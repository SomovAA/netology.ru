ansible-playbook:
	ansible-playbook -i ./infrastructure/inventory/cicd ./infrastructure/site.yml -vvv

ansible-playbook-prod-check:
	ansible-playbook -i ./infrastructure/inventory/cicd ./infrastructure/site.yml --check -vvv

ansible-playbook-prod-diff:
	ansible-playbook -i ./infrastructure/inventory/cicd ./infrastructure/site.yml --diff -vvv

ansible-lint:
	ansible-lint ./infrastructure/site.yml -v
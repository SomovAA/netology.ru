ansible-playbook:
	ansible-playbook -i ./infrastructure/inventory/cicd ./infrastructure/site.yml -vvv

ansible-playbook-prod-check:
	ansible-playbook -i ./infrastructure/inventory/cicd ./infrastructure/site.yml --check -vvv

ansible-playbook-prod-diff:
	ansible-playbook -i ./infrastructure/inventory/cicd ./infrastructure/site.yml --diff -vvv

ansible-lint:
	ansible-lint ./infrastructure/site.yml -v

sonar:
	~/sonar-scanner/bin/sonar-scanner \
      -Dsonar.projectKey=netology \
      -Dsonar.sources=. \
      -Dsonar.host.url=http://158.160.57.195:9000 \
      -Dsonar.login=31e1730df0d15125cfa9b4c16adc003cd9810310 \
      -Dsonar.coverage.exclusions=fail.py

mvn-version:
	mvn --version

mvn-package:
	mvn package /mvn
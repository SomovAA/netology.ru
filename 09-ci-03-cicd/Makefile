restart: docker-down docker-up

docker-up:
	docker-compose up -d --build

docker-down:
	docker-compose down

docker-down-clear:
	docker-compose down --volume

ansible-playbook:
	ansible-playbook -i ./infrastructure/inventory/cicd ./infrastructure/site.yml -vvv

ansible-playbook-prod-check:
	ansible-playbook -i ./infrastructure/inventory/cicd ./infrastructure/site.yml --check -vvv

ansible-playbook-prod-diff:
	ansible-playbook -i ./infrastructure/inventory/cicd ./infrastructure/site.yml --diff -vvv

ansible-lint:
	ansible-lint ./infrastructure/site.yml -v

systemctl-status-postgresql:
	docker exec -it sonar-01 sh -c 'systemctl status postgresql-11.service'

systemctl-status-sonar:
	docker exec -it sonar-01 sh -c 'systemctl status sonar.service'

psql:
	docker exec -it sonar-01 sh -c 'psql --dbname=sonar --username=sonar'

listen-ports-sonar:
	docker exec -it sonar-01 sh -c 'less /etc/services | grep sonar'

listen-ports-postgresql:
	docker exec -it sonar-01 sh -c 'less /etc/services | grep postgresql'

sysctl-max_map_count:
	docker exec -it sonar-01 sh -c 'sysctl -a | grep "vm.max_map_count"'

sysctl-50-default:
	docker exec -it sonar-01 sh -c 'cat /usr/lib/sysctl.d/50-default.conf | grep vm.max_map_count'

sysctl-10-default:
	docker exec -it sonar-01 sh -c 'cat /usr/lib/sysctl.d/10-default-yama-scope.conf | grep "vm.max_map_count"'

sysctl-system:
	docker exec -it sonar-01 sh -c 'sysctl --system'

proc-max_map_count:
	docker exec -it sonar-01 sh -c 'cat /proc/sys/vm/max_map_count'

proc-echo-max_map_count:
	docker exec -it sonar-01 sh -c 'echo 262144 > /proc/sys/vm/max_map_count'
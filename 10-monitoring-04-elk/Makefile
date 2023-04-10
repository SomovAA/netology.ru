restart: docker-down docker-up

docker-up:
	docker-compose -f ./help/docker-compose.yml up -d

docker-down:
	docker-compose -f ./help/docker-compose.yml down

docker-down-clear:
	docker-compose -f ./help/docker-compose.yml down --volume

sysctl-w-max_map_count:
	sudo sysctl -w vm.max_map_count=262144

ls-docker.sock:
	ls -la /var/run/ | grep docker.sock

chmod-docker.sock:
	sudo -S chmod 666 /var/run/docker.sock

sysctl-max_map_count:
	docker exec -it es-hot sh -c 'sysctl -a | grep "vm.max_map_count"'
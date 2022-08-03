up:
	docker-compose up -d

down:
	docker-compose down

down-clear:
	docker-compose down --volume

mysql-db:
	docker exec -it db mysql -uroot -proot

mysql-db-test-db:
	docker exec -it db mysql -uroot -proot -D test_db

pg-recovery:
	docker exec -it db sh -c 'mysql -uroot -proot test_db < /dump/test_dump.sql'

db-bash:
	docker exec -it db bash

db-bash-my-cnf:
	docker exec -it db cat /etc/my.cnf

pg-recovery-all:
	docker exec -it db sh -c 'mysql -uroot -proot < /dump/all-databases.sql'

db-dump-all:
	docker exec -it db sh -c 'mysqldump -uroot -proot --all-databases > /dump/all-databases.sql'

db-dump-all2:
	docker exec -it db mysqldump -uroot -proot -r /dump/all-databases.sql --all-databases
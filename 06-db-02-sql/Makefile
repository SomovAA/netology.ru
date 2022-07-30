up:
	docker-compose up -d

down:
	docker-compose down

down-clear:
	docker-compose down --volume

psql-db:
	docker exec -it db psql -U admin

psql-db-test-db:
	docker exec -it db psql -U admin -d test_db

psql-test-db:
	docker exec -it test_db psql -U admin

psql-test-db-test-db:
	docker exec -it test_db psql -U admin -d test_db

pg-dump:
	docker exec -t db pg_dump -U admin test_db -f /dump/dump_db.sql

pg-dump-all:
	docker exec -t db pg_dumpall -U admin -f /dump/dumpall_db.sql

pg-recovery:
	docker exec -it test_db psql -U admin -d test_db -f /dump/dump_db.sql

pg-recovery-all:
	docker exec -it test_db psql -U admin -f /dump/dumpall_db.sql
up:
	docker-compose up -d

down:
	docker-compose down

down-clear:
	docker-compose down --volume

psql-db:
	docker exec -it db psql -U postgres

psql-db-test-db:
	docker exec -it db psql -U postgres -d test_database

pg-dump:
	docker exec -t db pg_dump -U postgres test_database -f /dump/dump_db.sql

pg-recovery:
	docker exec -it db psql -U postgres -d test_database -f /dump/test_dump.sql

pg-recovery-new:
	docker exec -it db psql -U postgres -d test_database -f /dump/test_dump_example.sql
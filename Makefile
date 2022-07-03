postgres:
	docker run --name postgres-container -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres

createdb:
	docker exec -it postgres-container createdb --username=postgres simple_bank

dropdb:
	docker exec -it postgres-container dropdb --username=postgres simple_bank

migrateup:
	migrate -path db/migrations -database "postgresql://postgres:postgres@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migrations -database "postgresql://postgres:postgres@localhost:5432/simple_bank?sslmode=disable" -verbose down	

sqlc: 
	sqlc generate

remove:
	rm ./db/sqlc/*.go

test:
	go test -v -cover ./...

server: 
	go run main.go

mock:
	mockgen -destination db/mock/store.go -package mockdb github.com/zohaibAsif/simple_bank_management_system/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc remove test server


Command line:
terraform apply -var password=<db_password>>

DB query example:
PGPASSWORD=<db_password> psql -h <rds_endpoint> mydb foo \
-c "CREATE TABLE account(
 user_id serial PRIMARY KEY,
 username VARCHAR (50) UNIQUE NOT NULL,
 password VARCHAR (50) NOT NULL,
 email VARCHAR (355) UNIQUE NOT NULL,
 created_on TIMESTAMP NOT NULL,
 last_login TIMESTAMP
);"

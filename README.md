Commands:
terraform init
terraform apply -var password=<db_password>>
terraform destroy -var password=<db_password>>

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

# Three Tier Architecture

This is an implementation of the classic three tier architecture for application hosting
![c](https://image.slidesharecdn.com/webinarawsvsazure2015-04-08-150408164237-conversion-gate01/95/azure-vs-aws-best-practices-what-you-need-to-know-23-638.jpg?cb=1428512020 “three tier arch”)
There are three modules that constructs our architecture:
* network: link
* web: link
* db: link

## Deploying

Install t link https://something (or image)
Run this command

## Configuring
what can be configured init

## Inputs

| Name     | Description   | Type   | Default | Required |
| ------   | ------------- | :----: | :-----: | :-----:  |
| password | RDS password  | string | -       | yes      |

## Outputs

| Name         | Description   |
| ------       | ------------- |
| elb_dns      |               |
| rds_endpoint |               |

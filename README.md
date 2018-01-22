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

![Image of Yaktocat](https://image.slidesharecdn.com/webinarawsvsazure2015-04-08-150408164237-conversion-gate01/95/azure-vs-aws-best-practices-what-you-need-to-know-23-638.jpg?cb=1428512020)

This is an implementation of the classic three tier architecture for application hosting
Three modules that constructs our architecture:
* network: link
* web: link
* db: link

## How to deploying
* [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)
* Setup your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environmental variables
* Clone this project

Run the following command to deploy
* ```env=dev```
* ```terraform get -update=true```
* ```terraform init -backend-config=config/backend-${env}.conf```
* ```terraform plan -var-file=config/${env}.tfvars```
* ```terraform apply -var-file=config/${env}.tfvars```

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

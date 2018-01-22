# db
This module deploys PostgreSQL Database using AWS RDS

## What gets deployed
| Resource            | Description
| ---                 | ---
| Postgresql instance | The main configuration for Postgresql instance
| DB Subnet Group     | Defines which subnets the Postgresql instance is deployed to


## Inputs

| Name              | Description                                    | Type   | Default | Required |
| ------            | -------------                                  | :----: | :-----: | :-----:  |
| db_security_group | db_security_group                              | string | -       | yes      |
| db_subnet_b       | db_subnet_b                                    | string | -       | yes      |
| db_subnet_c       | db_subnet_c                                    | string | -       | yes      |
| main_vpc          | The port the server will use for HTTP requests | string | -       | yes      |
| password          | RDS password                                   | string | -       | yes      |

## Outputs

| Name         | Description   |
| ------       | ------------- |
| rds_endpoint |               |

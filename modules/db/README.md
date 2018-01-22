# db
This module deploys PostgreSQL Database using AWS RDS.

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

--------

### Run Command
After deployment, we can test the db connection using AWS Run Command.
Access the Run Command section in ec2 and select an instance to run command.
Then try the folloing DB query:
```
PGPASSWORD=<db_password> psql -h <rds_endpoint> mydb foo \
-c "CREATE TABLE account(
 user_id serial PRIMARY KEY,
 username VARCHAR (50) UNIQUE NOT NULL,
 password VARCHAR (50) NOT NULL,
 email VARCHAR (355) UNIQUE NOT NULL,
 created_on TIMESTAMP NOT NULL,
 last_login TIMESTAMP
);"
```
[For more information on Run Command click here](https://docs.aws.amazon.com/systems-manager/latest/userguide/run-command.html)

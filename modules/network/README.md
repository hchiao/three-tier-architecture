# network
This module deploys all the network resources
We deploy on two availability zones

## What gets deployed
|Resource         | Description
|---              | ---
|VPC              | The main vpc
|Internet Gateway | The internet gateway attached to vpc
|Subnets          | 2 public and 4 private subnets
|Network ACLs     | 1 public and 1 private NACLs
|Security Groups  | 1 public and 1 private security groups
|NATs             | 2 nats one for each availability zone


## Outputs
| Name             | Description   |
| ------           | ------------- |
| db_subnet_b      |               |
| db_subnet_c      |               |
| main_vpc         |               |
| private_sg       |               |
| private_subnet_b |               |
| private_subnet_c |               |
| public_sg        |               |
| public_subnet_b  |               |
| public_subnet_c  |               |

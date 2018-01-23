# Three Tier Architecture
[AWS Three Tier Architecture Reference](https://media.amazonwebservices.com/architecturecenter/AWS_ac_ra_web_01.pdf)

This is an implementation of the classic three tier architecture for application hosting.  <br />
Three modules that constructs our architecture:
* [network](https://github.com/hchiao/three-tier-architecture/tree/master/modules/network)
* [web](https://github.com/hchiao/three-tier-architecture/tree/master/modules/web)
* [db](https://github.com/hchiao/three-tier-architecture/tree/master/modules/db)

## How to deploy

Setup:
* [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)
* Setup your ```AWS_ACCESS_KEY_ID``` and ```AWS_SECRET_ACCESS_KEY``` environmental variables. (Assuming user have full permission)
* [Run Three Tier Init](https://github.com/hchiao/three-tier-init)
* Clone this project

Run commands to deploy:
* ```terraform init -backend-config=config/backend-dev.conf```
* ```terraform apply -var-file=config/dev.tfvars```

[Learn more Terraform command here](https://www.terraform.io/docs/commands/index.html)

## Inputs

| Name                  | Description                                           | Type   | Default | Required |
| ------                | -------------                                         | :----: | :-----: | :-----:  |
| allocated_storage     | The amount of allocated storage                       | string | -       | yes      |
| db_subnet_b_cidr      | The cidr range for db subnet b                        | string | -       | yes      |
| db_subnet_c_cidr      | The cidr range for db subnet c                        | string | -       | yes      |
| instance_class        | RDS instance class (e.g. db.t2.micro or db.m4.xlarge) | string | -       | yes      |
| multi_az              | Create a replica in different zone if set to true     | string | -       | yes      |
| password              | RDS password                                          | string | -       | yes      |
| private_subnet_b_cidr | The cidr range for private subnet b                   | string | -       | yes      |
| private_subnet_c_cidr | The cidr range for private subnet c                   | string | -       | yes      |
| public_subnet_b_cidr  | The cidr range for public subnet b                    | string | -       | yes      |
| public_subnet_c_cidr  | The cidr range for public subnet c                    | string | -       | yes      |
| skip_final_snapshot   | Creates a snapshot when db is deleted if set to true  | string | -       | yes      |
| username              | RDS username                                          | string | -       | yes      |
| vpc_cidr              | The cidr range for vpc                                | string | -       | yes      |

## Outputs

| Name         | Description               |
| ------       | -------------             |
| elb_dns      | Elastic Load Balancer DNS |
| rds_endpoint | RDS endpoint              |

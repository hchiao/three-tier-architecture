# Three Tier Architecture

![image](https://media.amazonwebservices.com/architecturecenter/AWS_ac_ra_web_01.pdf)

This is an implementation of the classic three tier architecture for application hosting
Three modules that constructs our architecture:
* [network](https://github.com/hchiao/three-tier-architecture/tree/master/modules/network)
* [web](https://github.com/hchiao/three-tier-architecture/tree/master/modules/web)
* [db](https://github.com/hchiao/three-tier-architecture/tree/master/modules/db)

## How to deploying

Setup:
* [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)
* Setup your ```AWS_ACCESS_KEY_ID``` and ```AWS_SECRET_ACCESS_KEY``` environmental variables
* Clone this project

Run commands to deploy:
* ```env=dev```
* ```terraform get -update=true```
* ```terraform init -backend-config=config/backend-${env}.conf```
* ```terraform plan -var-file=config/${env}.tfvars```
* ```terraform apply -var-file=config/${env}.tfvars```

[Learn more Terraform command here](https://www.terraform.io/docs/commands/index.html)

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

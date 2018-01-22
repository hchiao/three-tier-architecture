vpc_cidr              = "10.1.0.0/16"
public_subnet_b_cidr  = "10.1.1.0/24"
public_subnet_c_cidr  = "10.1.2.0/24"
private_subnet_b_cidr = "10.1.3.0/24"
private_subnet_c_cidr = "10.1.4.0/24"
db_subnet_b_cidr      = "10.1.5.0/24"
db_subnet_c_cidr      = "10.1.6.0/24"

username              = "prodfoo"
instance_class        = "db.t2.medium"
multi_az              = "true"
allocated_storage     = "12"
skip_final_snapshot   = "true"

#Cannot currently set to true due to issue: https://github.com/hashicorp/terraform/issues/5417
#skip_final_snapshot   = "false""

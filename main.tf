# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = "ap-southeast-2"
}

# ------------------------------------------------------------------------------
# RUNNING MODULES
# ------------------------------------------------------------------------------

module "network" {
  source = "./modules/network"
}

module "web" {
  source           = "./modules/web"
  public_subnet_b  = "${module.network.public_subnet_b}"
  public_subnet_c  = "${module.network.public_subnet_c}"
  private_subnet_b = "${module.network.private_subnet_b}"
  private_subnet_c = "${module.network.private_subnet_c}"
  public_sg        = "${module.network.public_sg}"
  private_sg       = "${module.network.private_sg}"
}

module "db" {
  source            = "./modules/db"
  main_vpc          = "${module.network.main_vpc}"
  db_subnet_b       = "${module.network.db_subnet_b}"
  db_subnet_c       = "${module.network.db_subnet_c}"
  db_security_group = "${module.network.private_sg}"
  password          = "${var.password}"
}

output "elb_dns" {
  value = "${module.web.elb_dns}"
}

output "rds_endpoint" {
  value = "${module.db.rds_endpoint}"
}

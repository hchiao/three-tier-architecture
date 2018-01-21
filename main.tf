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
  main_vpc         = "${module.site.main_vpc}"
  public_subnet_b  = "${module.site.public_subnet_b}"
  public_subnet_c  = "${module.site.public_subnet_c}"
  private_subnet_b = "${module.site.private_subnet_b}"
  private_subnet_c = "${module.site.private_subnet_c}"
  public_sg        = "${module.site.public_sg}"
  private_sg       = "${module.site.private_sg}"
}

module "db" {
  source            = "./modules/db"
  main_vpc          = "${module.site.main_vpc}"
  db_subnet_b       = "${module.site.db_subnet_b}"
  db_subnet_c       = "${module.site.db_subnet_c}"
  db_security_group = "${module.site.private_sg}"
  password          = "${var.password}"
}

output "elb_dns" {
  value = "${module.web.elb_dns}"
}

output "rds_endpoint" {
  value = "${module.db.rds_endpoint}"
}

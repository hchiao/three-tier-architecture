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
  source                = "./modules/network"
  vpc_cidr              = "${var.vpc_cidr}"
  public_subnet_b_cidr  = "${var.public_subnet_b_cidr}"
  public_subnet_c_cidr  = "${var.public_subnet_c_cidr}"
  private_subnet_b_cidr = "${var.private_subnet_b_cidr}"
  private_subnet_c_cidr = "${var.private_subnet_c_cidr}"
  db_subnet_b_cidr      = "${var.db_subnet_b_cidr}"
  db_subnet_c_cidr      = "${var.db_subnet_c_cidr}"
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
  source              = "./modules/db"
  main_vpc            = "${module.network.main_vpc}"
  db_subnet_b         = "${module.network.db_subnet_b}"
  db_subnet_c         = "${module.network.db_subnet_c}"
  db_security_group   = "${module.network.private_sg}"
  username            = "${var.username}"
  password            = "${var.password}"
  instance_class      = "${var.instance_class}"
  multi_az            = "${var.multi_az}"
  allocated_storage   = "${var.allocated_storage}"
  skip_final_snapshot = "${var.skip_final_snapshot}"
}

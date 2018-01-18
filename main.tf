# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = "ap-southeast-2"
}

# ------------------------------------------------------------------------------
# RUNNING MODULES
# ------------------------------------------------------------------------------

module "site" {
  source = "./modules/site"
}

#module "web" {
  #source                  = "./modules/web"
  #instance_subnet         = "${module.site.instance_subnet}"
  #instance_security_group = "${module.site.instance_security_group}"
#}

#output "public_ip" {
  #value = "${module.web.public_ip}"
#}

#module "auto_scaling" {
  #source = "./modules/auto_scaling"
  #main_vpc = "${module.site.main_vpc}"
  #subnet_b = "${module.site.subnet_b}"
  #subnet_c = "${module.site.subnet_c}"
#}

#output "elb_dns" {
  #value = "${module.auto_scaling.elb_dns}"
#}

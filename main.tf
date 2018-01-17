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

module "web" {
  source                  = "./modules/web"
  instance_subnet         = "${module.site.instance_subnet}"
  instance_security_group = "${module.site.instance_security_group}"
}

output "public_ip" {
  value = "${module.web.public_ip}"
}

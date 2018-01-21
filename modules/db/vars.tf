variable "main_vpc" {
  description = "The port the server will use for HTTP requests"
}

variable "password" {
  description = "RDS password"
}

variable "db_subnet_b" {
  description = "db_subnet_b"
}

variable "db_subnet_c" {
  description = "db_subnet_c"
}

variable "db_security_group" {
  description = "db_security_group"
}

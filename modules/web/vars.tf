# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 80
}

variable "main_vpc" {
    type = "string"
}

variable "public_subnet_b" {
    type = "string"
}

variable "public_subnet_c" {
    type = "string"
}
variable "private_subnet_b" {
    type = "string"
}
variable "private_subnet_c" {
    type = "string"
}

variable "public_sg" {
    type = "string"
}

variable "private_sg" {
    type = "string"
}

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

variable "subnet_b" {
    type = "string"
}

variable "subnet_c" {
    type = "string"
}

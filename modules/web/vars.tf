# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 80
}

variable "instance_subnet" {
    type = "string"
}

variable "instance_security_group" {
    type = "string"
}

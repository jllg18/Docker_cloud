variable "access_key" {
  description = "AWS Access Key"
  default     = "AKIA3NQACJY46AD3CRHM"
}

variable "secret_key" {
    description = "AWS Secret Key"
    default     = "Czu6sMDVJiOK6aJlrCchsPJbecvt2Nyy9BNCLb9Q"
}
variable "ami_id" {
  description = "CentOs"
  default = "ami-0144c00a28e5f20bf"
}

variable "instance_type" {
  description = "Instance type Used"
  default = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet_id"
  default = "172.1.0.0/24"
}

variable "nameapp1" {
  default = "Docker Votting"
}

variable "Env" {
  default = "Desarrollo"
}

variable "key_name" {
  description = "The AWS key name"
  default = "dockervot"
}
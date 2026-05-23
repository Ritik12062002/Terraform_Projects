variable "primary_region" {
  type = string
  default = "us-east-1"
}

variable "secondary_region" {
  type = string
  default = "us-west-2"
}

variable "primary_vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  type = string
  default = "10.1.0.0/16"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}
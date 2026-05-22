# terraform {
#   backend "s3" {
#       key = "dev/terraform.tfstate"
#       bucket = "ritik-terraform-state-04-05-26"
#       region = "us-east-1"
#       encrypt = true
#       use_lockfile = true
#     }
# }
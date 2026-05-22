variable "bucket_name" {
  default = "ritik-s3-website-hosting-21-05-26"
}

variable "tags" {
  type = map(string)
  default = {
    Name = "ritik-s3-website-hosting-21-05-26"
    Environment = "dev"
    owner = "Ritik sharma"
    purpose = "Static website hosting"
    project = "cyber-security-operations-interactive-engine"
    team = "DevOps Team"    
  }
}


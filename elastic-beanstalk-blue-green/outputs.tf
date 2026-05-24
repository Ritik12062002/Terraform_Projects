output "blue_environment_url" {
  value = aws_elastic_beanstalk_environment.blue.cname
}

output "green_environment_url" {
  value = aws_elastic_beanstalk_environment.green.cname
}

output "blue_environment_name" {
  value = aws_elastic_beanstalk_environment.blue.name
}

output "green_environment_name" {
  value = aws_elastic_beanstalk_environment.green.name
}
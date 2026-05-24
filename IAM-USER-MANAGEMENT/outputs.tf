
output "user_name" {
    value = {
        for key,value in aws_iam_user.users:
        key => value.name
    }
}


output "login_passwords" {
  sensitive = true

  value = {
    for key, value in aws_iam_user_login_profile.users :
    key => value.password
  }
}
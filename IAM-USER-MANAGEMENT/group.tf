resource "aws_iam_group" "education" {
  name = "education"
  path =  "/groups/"
}

resource "aws_iam_group" "engineering" {
  name = "engineering"
  path = "/groups/"
}

resource "aws_iam_group" "management" {
  name = "management"
  path =  "/groups/"
}


resource "aws_iam_group_membership" "education_members" {
  name ="education-membership"
  
  users = [
    for user_key, user in aws_iam_user.users : user.name
    if  user.tags.Department == "education"
  ]
  group = aws_iam_group.education.name
}


resource "aws_iam_group_membership" "engineering_members" {
  name = "engineering-membership"

  users = [
    for user_key, user in aws_iam_user.users : user.name
    if user.tags.Department == "engineering"
  ]

  group = aws_iam_group.engineering.name
}

resource "aws_iam_group_membership" "management_members" {
  name = "management-membership"

  users = [
    for user_key, user in aws_iam_user.users : user.name
    if user.tags.Department == "management"
  ]

  group = aws_iam_group.management.name
}


resource "aws_s3_object" "blue_app" {
  bucket = aws_s3_bucket.eb_bucket.id

  key = "app-v1.zip"
  source = "app-v1/app-v1.zip"

  etag = filemd5("app-v1/app-v1.zip")
}


resource "aws_elastic_beanstalk_application_version" "v1" {
  name = "v1"
  application = aws_elastic_beanstalk_application.app.name

  bucket = aws_s3_bucket.eb_bucket.id
  key    = aws_s3_object.blue_app.key
}

resource "aws_elastic_beanstalk_environment" "blue" {
  name         = "${var.app_name}-blue"
  application  = aws_elastic_beanstalk_application.app.name

   solution_stack_name = "64bit Amazon Linux 2023 v6.11.0 running Node.js 20"

  version_label = aws_elastic_beanstalk_application_version.v1.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.eb_service_role.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NODE_ENV"
    value     = "production"
  }

  tags = {
    Environment = "Blue"
  }
}
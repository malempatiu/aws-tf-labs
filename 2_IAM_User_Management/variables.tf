variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "user_groups" {
  description = "For a collection of IAM users and to specify permissions for collection of users"
  type        = map(string)
  default = {
    developers = "Development"
    operations = "Devops"
  }
}
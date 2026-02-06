resource "aws_iam_group" "groups" {
  for_each = var.user_groups
  name     = each.key
  path     = "/users/"
}
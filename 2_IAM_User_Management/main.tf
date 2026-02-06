data "aws_caller_identity" "current" {}

resource "aws_iam_user" "users" {
  for_each = { for user in local.users : user.first_name => user }
  name     = "${each.value.first_name}-${each.value.last_name}"
  tags = {
    "DisplayName" = each.value.first_name
    "Department"  = each.value.department
    "JobTitle"    = each.value.job_title
  }
}


resource "aws_iam_group_membership" "memberships" {
  for_each = aws_iam_group.groups
  name     = "${each.value.name}-membership"
  group    = each.value.name
  users    = [for user in aws_iam_user.users : user.name if lower(lookup(user.tags, "Department", "")) == lower(var.user_groups[each.value.name])]
}

resource "aws_iam_user_login_profile" "users" {
  for_each                = aws_iam_user.users
  user                    = each.value.name
  password_reset_required = true
}

resource "aws_iam_group_policy_attachment" "policies" {
  for_each = aws_iam_group.groups
  group    = each.value.name
  policy_arn = each.value.name == "operations" ? "arn:aws:iam::aws:policy/AdministratorAccess" : "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
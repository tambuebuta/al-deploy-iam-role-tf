// Set output

output "alertlogic_iam_role_arn" {
  value = "${aws_iam_role.alertlogic-role.arn}"
}

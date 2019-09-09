output "username" {
  value = "${aws_ssm_parameter.postgresql_username_ssm.value}"
}

output "password" {
  value = "${aws_ssm_parameter.postgresql_password_ssm.value}"

}

output "username_ssm_name" {
  value = "${aws_ssm_parameter.postgresql_username_ssm.name}"
}

output "password_ssm_name" {
  value = "${aws_ssm_parameter.postgresql_password_ssm.name}"

}
output "kms_key_id" {
  value = "${aws_kms_key.postgres_kms.key_id}"
}
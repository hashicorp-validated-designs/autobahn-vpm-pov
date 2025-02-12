
output "iam_role_arn" {
  description = "ARN of the IAM role to be assumed by the HCP Terraform organization"
  value       = aws_iam_role.vpm_pov_provisioner_role.arn

}

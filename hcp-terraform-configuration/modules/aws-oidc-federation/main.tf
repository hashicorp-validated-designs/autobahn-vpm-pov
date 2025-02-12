#
# 
#

data "aws_iam_policy_document" "pov_oidc_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.aws_oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    }

    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values = [
        "organization:${var.hcp_terraform_organization}:project:${var.hcp_terraform_project}:workspace:*:run_phase:plan",
        "organization:${var.hcp_terraform_organization}:project:${var.hcp_terraform_project}:workspace:*:run_phase:apply"
      ]
    }
  }
}

resource "aws_iam_role" "vpm_pov_provisioner_role" {
  name               = "hcp-terraform-workload-identity-${var.hcp_terraform_project}"
  description        = "Role to allow the HCP Terraform organization to assume the role"
  assume_role_policy = data.aws_iam_policy_document.pov_oidc_assume_role_policy.json
}

#
# Additional permissions for the role
#

# Add EC2 permissions to the role
data "aws_iam_policy" "pov_ec2_permissions" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"

}

resource "aws_iam_role_policy_attachment" "pov_ec2_permissions" {
  role       = aws_iam_role.vpm_pov_provisioner_role.name
  policy_arn = data.aws_iam_policy.pov_ec2_permissions.arn

}

# Add S3 permissions to the role
data "aws_iam_policy" "pov_s3_permissions" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"

}

resource "aws_iam_role_policy_attachment" "pov_s3_permissions" {
  role       = aws_iam_role.vpm_pov_provisioner_role.name
  policy_arn = data.aws_iam_policy.pov_s3_permissions.arn

}

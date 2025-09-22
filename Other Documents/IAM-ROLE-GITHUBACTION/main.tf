provider "aws" {
  region = var.region
}


# Create the GitHub OIDC provider (only once per account)
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

#create IAM role policy to temporarily gain permissions associated with this.
data "aws_iam_policy_document" "github_oidc_assume_role" { 
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:*"]
    }
  }
}

#Create IAM role and attached the assumed role policy
resource "aws_iam_role" "github_oidc" {
  name = var.iam_role_githubaction_tag

  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

#Create incline policy for the github_oidc role
data "aws_iam_policy_document" "github_oidc_policy" {
  statement {
    sid    = "AllowTerraformAccess"
    effect = "Allow"

    actions = [
      "ec2:*",
      "rds:*",
      "iam:*",
      "s3:*",
      "ssm:*",
      "cloudwatch:*",
      "logs:*",
      "elasticloadbalancing:*",
      "autoscaling:*"
    ]

    resources = ["*"]
  }
}

# Attached the inclined policy to iam role
resource "aws_iam_role_policy" "github_oidc_inline_policy" {
  name = "GitHubActionAccess"
  role = aws_iam_role.github_oidc.id

  policy = data.aws_iam_policy_document.github_oidc_policy.json
}
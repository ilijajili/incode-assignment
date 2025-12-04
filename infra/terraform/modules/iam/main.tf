variable "project_name" { type = string }
variable "create_github_oidc_provider" {
  type    = bool
  default = false
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.create_github_oidc_provider ? 0 : 1
  url   = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_github_oidc_provider ? 1 : 0

  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

locals {
  github_oidc_provider_arn = coalesce(
    try(data.aws_iam_openid_connect_provider.github[0].arn, null),
    try(aws_iam_openid_connect_provider.github[0].arn, null)
  )
}

resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-gha-oidc"
  assume_role_policy = data.aws_iam_policy_document.github_assume.json
}

data "aws_iam_policy_document" "github_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [local.github_oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = ["repo:OWNER/REPO:*" ]
    }
  }
}

resource "aws_iam_role_policy" "github_actions_policy" {
  name = "${var.project_name}-gha-policy"
  role = aws_iam_role.github_actions.id

  policy = data.aws_iam_policy_document.github_inline.json
}

data "aws_iam_policy_document" "github_inline" {
  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
      "eks:DescribeUpdate",
      "ecr:*",
      "sts:AssumeRole",
      "ssm:GetParameter",
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }
}

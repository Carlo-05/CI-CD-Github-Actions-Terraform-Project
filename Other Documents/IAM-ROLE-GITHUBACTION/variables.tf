variable "region" {
  description = "value"
  default = "us-west-2"
}

variable "github_repo" {
  description = "value"
  default = "Carlo-05/CI-CD-Github-Actions-Terraform-Project"
}

#tags
variable "iam_role_githubaction_tag" {
  description = "value"
  default = "github_actions_test"
}
variable "region" {
  description = "value"
  default = "<Desired Region>"
}

variable "github_repo" {
  description = "value"
  default = "<Your Repository>/CI-CD-Github-Actions-Terraform-Project"
}

#tags
variable "iam_role_githubaction_tag" {
  description = "value"
  default = "github_actions_test"

}

terraform {
  backend "s3" {
    bucket = "cattleya-essai-005"
    key = "GitHubAction/terraform.tfstate"
    region = "us-west-2"
  }
}
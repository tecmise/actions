data "terraform_remote_state" "api-gateway" {
  backend = "s3"
  config = {
    bucket = var.terraform_bucket
    key = "infra-aws-api-gateway.tfstate"
    region = "us-east-1"
  }
}

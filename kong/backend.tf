terraform {
  backend "s3" {
    bucket = "kong-terraform-backend-bucket"
    key    = "kong-terraform-aws/kong/terraform.tfstate"
    region = "ca-central-1"
  }
}

    #access_key => is provided through env variable AWS_ACCESS_KEY_ID
    #secret_key => is provided through env variable AWS_SECRET_ACCESS_KEY 

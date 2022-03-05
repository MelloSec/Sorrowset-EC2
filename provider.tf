terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    # cloudflare = {
    #   source = "cloudflare/cloudflare"
    #   version = "~> 3.0"
    # }
    local = ">= 1.2"
  }
}
provider "aws" {
  region     = "us-east-1"
  // access_key = var.aws_access_key
  // secret_key = var.aws_secret_key
  profile = "default"
}

# provider "cloudflare" {
#   email   = ""
#   api_token = ""
# }

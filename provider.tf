terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    local = ">= 1.2"
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    endpoint                    = "nyc3.digitaloceanspaces.com"
    bucket                      = "hackerops"
    key                         = "sorrowset"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    access_key                  = null
    secret_key                  = null
    acl                         = "private"
    force_path_style            = true
  }
}

provider "aws" {
  region     = "us-east-1"
  profile    = "default"
}

provider "digitalocean" {
  token = var.do_token
}

// export DO_TOKEN
// export AWS_ACCESS_KEY_ID=
// export AWS_SECRET_ACCESS_KEY=
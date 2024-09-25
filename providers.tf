terraform {
  required_providers {
    aws = {
      source = "hc-registry.website.k2.cloud/c2devel/rockitcloud"
      # source  = "c2devel/rockitcloud"
      version = "24.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    remote = {
      source  = "tenstad/remote"
      version = "0.1.3"
    }
  }
}

provider "aws" {
  endpoints {
    ec2 = "https://ec2.k2.cloud"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  insecure   = false
  access_key = local.EC2_ACCESS_KEY
  secret_key = var.admin.EC2_SECRET_KEY
  region     = "region-1"
}

provider "aws" {
  alias = "noregion"
  endpoints {
    s3 = "https://s3.k2.cloud"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  insecure   = false
  access_key = local.EC2_ACCESS_KEY
  secret_key = var.admin.EC2_SECRET_KEY
  region     = "us-east-1"
}

provider "remote" {
  # Configuration options
}
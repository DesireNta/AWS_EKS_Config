terraform {
  required_version = "~>0.12.0"
  required_providers {
    aws = "~>2.27.0"
  }
}

provider "aws" {}

terraform {
  backend "s3" {
    bucket = "dawan-20200224-terraform-state"
    key    = "states/stagiaire05/mes-1"
    region = "eu-west-3"
  }
}

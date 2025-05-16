provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "nti-shehab-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}

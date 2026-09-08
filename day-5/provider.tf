provider "aws" {
  region = "ap-south-1"
  profile = "dev"
}


terraform{
    backend "s3" {
        bucket = "deploybyanushree-terraform-state"
        key    = "terraform.tfstate"
        region = "ap-south-1"
        profile = "dev"
        use_localstate = true
        shared_credentials_file = "C:/Users/Admin/.aws/credentials"
    }
}
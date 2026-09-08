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
        use_lockfile = true
        shared_credentials_file = ["/root/.aws/credentials"]
    }
}
resource "random_id" "random_id" {
   byte_length = 8
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-bucket-${terraform.workspace}-${random_id.random_id.hex}"
  acl    = "private"
    tags = {
        Name        = "my-bucket-${terraform.workspace}"
       
    }
}
resource "aws_instance" "public_instance" {
   ami           = "ami-0c55b159cbfafe1f0"
   instance_type = "t3.micro"
   key_name      = "med-erp-key"
   count        = 2
   vpc_security_group_ids = ["sg-0e3f1b2c3d4e5f6g7"]
   tags = {
     Name = "public_instance"
   }
  
}
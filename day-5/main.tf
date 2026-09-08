resource "aws_instance" "public_instance" {
   ami           = "ami-01a00762f46d584a1"
   instance_type = "t3.micro"
   key_name      = "med-erp-key"
   count        = 2
   vpc_security_group_ids = ["sg-0e7fe9ac18d6d1d74"]
   tags = {
     Name = "public_instance"
   }
  
}
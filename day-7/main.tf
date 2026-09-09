resource "aws_instance" "ec2_instance" {
    for_each = tomap ({
        server-1 = "t3.micro"
        server-2 = "t3.small"
        server-3 = "t3.medium"
})
  ami           = "ami-01a00762f46d584a1"
  instance_type = each.value
  key_name      = "med-erp-key" 
  tags = {
    Name = each.key
  }
}
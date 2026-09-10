resource "aws_instance" "example" {
  instance_type          = "t3.micro"
  ami                    = "ami-01a00762f46d584a1"
  key_name               = "med-erp-key"
  count                  = 2
  subnet_id              = "subnet-08a60be5a846abf93"
vpc_security_group_ids = [" vpc-034557982824d4277"]
  provisioner "file" {
    source      = "hello.txt"
    destination = "/home/ubuntu/hello.txt"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/med-erp-key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}
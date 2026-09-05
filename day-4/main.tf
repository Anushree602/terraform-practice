module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
    public_subnet_cidr ="10.0.0.0/22"
    private_subnet_cidr = "10.0.4.0/22"
    public_subnet_az = "ap-south-1a"
    private_subnet_az = "ap-south-1a"
    sg_name = "my_sg"
    http_port = 80
    ssh_port = 22
}

module "ec2" {
  source = "./modules/ec2"
  ami = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  key_name = "med-erp-key"
  sg_id = module.vpc.security_group_id
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
}
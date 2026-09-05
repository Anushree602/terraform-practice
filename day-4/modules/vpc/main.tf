resource "aws_vpc" "my_vpc" {
  cidr_block = "0.0.0/16"
    tags = {
        Name = "my_vpc"
    }
  
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "0.0.1/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "private_subnet"
  }
}

    resource "aws_internet_gateway" "my_igw" {
      vpc_id = aws_vpc.my_vpc.id
      tags = {
        Name = "my_igw"
      }
    }

    resource  "aws_eip" "nat_eip" {
      domain = "vpc"
      tags = {
        Name = "nat_eip"
      }
    }

    resource "aws_nat_gateway" "my_nat_gw" {
      allocation_id = aws_eip.nat_eip.id
      subnet_id     = aws_subnet.public_subnet.id
      tags = {
        Name = "my_nat_gw"
      }
    }

    resource "aws_route_table" "public_rt" {
      vpc_id = aws_vpc.my_vpc.id
      route {
        cidr_block = "0.0.0/0"
        gateway_id = aws_igw.my_igw.id  
      }
        tags = {
            Name = "public_rt"
        }
    }

    resource aws_route_table_association "public_rt_assoc" {
      subnet_id      = aws_subnet.public_subnet.id
      route_table_id = aws_route_table.public_rt.id
    }

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gw.id   
  }
    tags = {
        Name = "private_rt"
    }
}

resource aws_route_table_association "private_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
        Name = "my_sg"
    }   
}
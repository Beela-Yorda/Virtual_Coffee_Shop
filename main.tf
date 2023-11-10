
# Configuring the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Creating a VPC
resource "aws_vpc" "vcs_vpc" {
  cidr_block = "10.0.0.0/18" 

  tags = {
    Name = "vcs_vpc"
  }
}

# Creating a network ACL

resource "aws_network_acl" "vcs_acl" {
  vpc_id = aws_vpc.vcs_vpc.id 

}


# Creating two public and two private subnets within the VPC
resource "aws_subnet" "public_vcs1" {
  vpc_id                  = aws_vpc.vcs_vpc.id
  cidr_block              = "10.0.1.0/24" 
  availability_zone       = "us-east-1a" 

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_vcs1" {
  vpc_id                  = aws_vpc.vcs_vpc.id
  cidr_block              = "10.0.2.0/24" 
  availability_zone       = "us-east-1b" 

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_subnet" "public_vcs2" {
  vpc_id                  = aws_vpc.vcs_vpc.id
  cidr_block              = "10.0.3.0/24" 
  availability_zone       = "us-east-1c" 

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_vcs2" {
  vpc_id                  = aws_vpc.vcs_vpc.id
  cidr_block              = "10.0.4.0/24" 
  availability_zone       = "us-east-1d" 

  tags = {
    Name = "Private Subnet"
  }
}


# Creating a security group
resource "aws_security_group" "vcs_sg" {
  vpc_id = aws_vpc.vcs_vpc.id
  tags = {
    Name = "vcs_sg"
  }

}

#Creating a key pair 
resource "aws_key_pair" "vcs_key" {
key_name = "vcs_key"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfKL8oiMrAvijAqOMa9ajGOb7k7z9a691Gmf8xtaPKFOg0Wqcu35ascM6vjRlaPtpkBA/MDy0bjfPzbZV19LOE92LbUQfwW9aRMBpYACMSPLyR0e2plT4o81QUIOpUIebgjxvpq+DsDOQdCb+MmGz9L0RN8e8vnUV4Pr2jJzOabdQ2aVtIkks2iDJ4Pexq73zpU13Xx8YUWPQmPPU/NhYezSmvZZuL90kSUvsHj1ivu5pwqbYDZqSNAagfIwD9XSOLxhgUUGtQPTcIcXiOdun0O5+WQ+uFw13zU8kBOGU04qliaFu+UZ/IHwNf+qy7L3E+529FsGvBi2kCY+aaP9nT Nabila@PSL-NABILA"

}


# Launching four (4) EC2 instance

resource "aws_instance" "public_1" {
  ami               = "ami-0e8a34246278c21e4" 
  instance_type     = "t2.micro"              
  key_name          = "vcs_key"    
  subnet_id         = aws_subnet.public_vcs1.id
  #security_group_id = aws_security_group.vcs_sg.id

  tags = {
    Name = "public 1"
  }
}

resource "aws_instance" "private_1" {
  ami               = "ami-0e8a34246278c21e4" 
  instance_type     = "t2.micro"              
  key_name          = "vcs_key"    
  subnet_id         = aws_subnet.private_vcs1.id
  #security_group_id = aws_security_group.vcs_sg.id

  tags = {
    Name = "private 1"
  }
}

resource "aws_instance" "public_2" {
  ami                = "ami-0e8a34246278c21e4" 
  instance_type      = "t2.micro"              
  key_name           = "vcs_key"    
  subnet_id          = aws_subnet.public_vcs2.id
  #security_group_id  = aws_security_group.vcs_sg.id

  tags = {
    Name = "public 2"
  }
}

resource "aws_instance" "private_2" {
  ami                = "ami-0e8a34246278c21e4" 
  instance_type      = "t2.micro"              
  key_name           = "vcs_key"    
  subnet_id          = aws_subnet.private_vcs2.id
  #security_group_id  = aws_security_group.vcs_sg.id

  tags = {
    Name = "private 2"
  }
}

# Creating an Application Load Balancer


resource "aws_lb" "vcs_lb"{
  internal           = false
  load_balancer_type = "application"
  #security_groups_id = aws_security_group.vcs_sg.id 
  subnets            = ["public_vcs1", "public_vcs2"]

  enable_deletion_protection = false 

  enable_http2       = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "vcs_lb"
  }

}
  



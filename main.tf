
# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "vcs_vpc" {
  cidr_block = "10.0.0.0/18" 

  tags = {
    Name = "vcs_vpc"
  }
}

# Create a network ACL

resource "aws_network_acl" "vcs_acl" {
  vpc_id = aws_vpc.vcs_vpc.id 

}


# Create two public and two private subnets within the VPC
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


# Create a security group
resource "aws_security_group" "vcs_sg" {
  vpc_id = aws_vpc.vcs_vpc.id

  tags = {
    Name = "vcs_sg"
  }

}

#Create a key pair 
resource "aws_key_pair" "vcs_key" {
key_name = "vcs_key"
}


# Launch four (4) EC2 instance

resource "aws_instance" "public_1" {
  ami               = "ami-0e8a34246278c21e4" 
  instance_type     = "t2.micro"              
  key_name          = "vcs_key"    
  subnet_id         = aws_subnet.public_vcs1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.vcs_sg.id]

  tags = {
    Name = "public 1"
  }
}

resource "aws_instance" "private_1" {
  ami               = "ami-0e8a34246278c21e4" 
  instance_type     = "t2.micro"              
  key_name          = "vcs_key"    
  subnet_id         = aws_subnet.private_vcs1.id
  vpc_security_group_ids = [aws_security_group.vcs_sg.id]
 
  tags = {
    Name = "private 1"
  }
}

resource "aws_instance" "public_2" {
  ami                = "ami-0e8a34246278c21e4" 
  instance_type      = "t2.micro"              
  key_name           = "vcs_key"    
  subnet_id          = aws_subnet.public_vcs2.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.vcs_sg.id]

  tags = {
    Name = "public 2"
  }
}

resource "aws_instance" "private_2" {
  ami                = "ami-0e8a34246278c21e4" 
  instance_type      = "t2.micro"              
  key_name           = "vcs_key"    
  subnet_id          = aws_subnet.private_vcs2.id
  vpc_security_group_ids = [aws_security_group.vcs_sg.id]
  

  tags = {
    Name = "private 2"
  }
}

#Create an Internet Gateway

resource "aws_internet_gateway" "vcs_igw" {
  vpc_id = aws_vpc.vcs_vpc.id 

  tags = {
    Name = "vcs_igw"
  }
}

# Create an Application Load Balancer


resource "aws_lb" "vcs_alb" {
  internal                         = false
  load_balancer_type               = "application"
  subnets                          = [aws_subnet.public_vcs1.id, aws_subnet.public_vcs2.id]
  enable_deletion_protection       = false
  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "vcs_alb"
  }
}


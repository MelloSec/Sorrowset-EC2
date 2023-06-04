module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "sorrowset-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  enable_dns_hostnames = true

  tags = { 
    Terraform = "true"
    project   = "sorrowset"
  }
}

module "ami-search" {
  source = "./modules/ami-search"
  os     = var.ec2_img
}

module "ansible_key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name   = "ansible_sorrowset"
  public_key = file("${var.ssh_public_key_location}")
}

module "sorrowset_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sorrowset3-sg"
  description = "Security group sorrowset instance"
  vpc_id      = module.vpc.vpc_id
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow All Outbound"
    },
  ]
  
ingress_with_cidr_blocks = [
  {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    description = "Wireguard"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = "0.0.0.0/0"
  },
]


  
  tags = {
    Terraform = "true"
    project   = "sorrowset"
  }
}

module "sorrowset_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  count = 1
  name           = "sorrowset-vm-1"
  ami                    = module.ami-search.ami_id
  associate_public_ip_address = true
  instance_type          = "t2.micro"
  key_name               = "ansible_sorrowset"
  monitoring             = true
  vpc_security_group_ids = [module.sorrowset_sg.security_group_id]
  subnet_id             = tolist(module.vpc.public_subnets)[count.index]
  user_data              = data.template_cloudinit_config.config.rendered
  root_block_device = [{
    volume_type = "gp2"
    volume_size = 50
  }]
  tags = {
    Terraform = "true"
    project = "sorrowset"
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false
  #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #! /bin/bash
    export PATH=$PATH:/usr/bin
    sudo apt-get update
    sudo adduser --disabled-password --gecos '' ansible
    sudo mkdir -p /home/ansible/.ssh
    sudo touch /home/ansible/.ssh/authorized_keys
    sudo echo '${file("${var.ssh_public_key_location}")}' > authorized_keys
    sudo mv authorized_keys /home/ansible/.ssh
    sudo chown -R ansible:ansible /home/ansible/.ssh
    sudo chmod 700 /home/ansible/.ssh
    sudo chmod 600 /home/ansible/.ssh/authorized_keys
    sudo usermod -aG sudo ansible
    sudo echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers
    EOF
  }
}


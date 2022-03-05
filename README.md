# Sorrowset EC2
## _Attack VMs for everyone_

## Features

- Terraform to create server, networking and setup Ansible User
- Ansible to further configure, install Docker/Compose, containers 

#### [ _What Terraform's Doing_ ]

###### 1. Terraform reaches out to AWS APIs and provisions a VPC, subnets, project tags.
- Change the `CIDR`, `subnets`, `region` and `tags` under `main.tf`
- Optional Cloudflare DNS Provider commented out under `provider.tf`
- Varialbes: `ec2_image` `ssh_public_key_location`

###### 2. Terraform calls the AMI search module to turn our specs into the correct AMI ID
- Outputs `ami_id` `root_device_name` `owner_id`

###### 3. Terraform calls the SSH keypair module to create an AWS keypair from yout public key
- `public_key = file("${var.ssh_public_key_location}")`

###### 4. Terraform configures Security Group module and opens up the firewall
- Add IP addresses under `ingress_with_cidr_blocks`

###### 5. Terraform calls sorrowset_EC2 Module and builds our server
- Could change the `name` `instance_type` `key_name` `monitoring` and `volume` information

###### 5. Terraform runs shell code, updates VM, creates ansible user, adds keys, passwordless sudo
- Change it if you want a different `ansible` user

## Instructions

###### - Make sure you have Terraform, the AWS-CLI and Ansible installed on your workstation.
###### - Terraform will save state on your workstation, S3/Cloud storage or a Workspace (Hashicorp, Github)
###### - Ansible roles will install on your workstation and do not need to be installed on the remote VM

 
###### 1. Update, install ansible, terraform, aws

```sh
# Install ansible
sudo apt install -y ansible

# Install terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Install AWS cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

###### 2. Make your mods to `main.tf`, `inventory.yml`, ``providers.tf`, `variables.tf`

 See above '_What Terraform's Doing_'

###### 3. Configure AWS cli with your Access Key and Secret Access Key from the AWS management console
`
aws configure
`

###### 4. Initialize Terraform project, Plan and Apply Changes
See how your plan looks, then tell terraform to spin it up.

```
terraform init
terraform plan
terraform apply --auto-approve
```

###### 5. Take the output IP address and put it into the host name under `inventory.yml`

```
terraform output
```

###### 6. Customize first run deployment by comment/uncomment roles under `deploy.yml` 

###### 7. Run the deploy.yml playbook



## ToDo

- [x] Test
- [ ] Test2

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

| Plugin | README |
| ------ | ------ |
| Dropbox | [plugins/dropbox/README.md][PlDb] |
| GitHub | [plugins/github/README.md][PlGh] |
| Google Drive | [plugins/googledrive/README.md][PlGd] |
| OneDrive | [plugins/onedrive/README.md][PlOd] |
| Medium | [plugins/medium/README.md][PlMe] |
| Google Analytics | [plugins/googleanalytics/README.md][PlGa] 




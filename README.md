# Sorrowset EC2
## _Attack VMs for everyone_

## Features

- Terraform to create server, networking and setup Ansible User
- Ansible to further configure, install Docker/Compose, containers 

## What's Happening Here

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

`
sudo apt
`

```sh
cd dillinger
npm i
node app
```


| Plugin | README |
| ------ | ------ |
| Dropbox | [plugins/dropbox/README.md][PlDb] |
| GitHub | [plugins/github/README.md][PlGh] |
| Google Drive | [plugins/googledrive/README.md][PlGd] |
| OneDrive | [plugins/onedrive/README.md][PlOd] |
| Medium | [plugins/medium/README.md][PlMe] |
| Google Analytics | [plugins/googleanalytics/README.md][PlGa] 


## ToDo

- [x] Test
- [ ] Test2

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

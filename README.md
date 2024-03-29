# Sorrowset EC2
## _Sad, Fat and full of Evil_


## Features

- Spin up an Attack VM/Container host on AWS
  
- Terraform to create server, networking and setup Ansible User
  
- Ansible to further configure, install Docker/Compose, containers 


#### [ _What Terraform's Doing_ ]


###### 1. Terraform reaches out to AWS APIs and provisions a VPC, subnets, project tags.
- Change the `CIDR`, `subnets`, `region` and `tags` under `main.tf`
- Optional Cloudflare DNS Provider commented out under `provider.tf`
- Variables: `ec2_image` `ssh_public_key_location`


###### 2. Terraform calls the AMI search module to turn our specs into the correct AMI ID
- Outputs `ami_id` `root_device_name` `owner_id`


###### 3. Terraform calls the SSH keypair module to create an AWS keypair from yout public key
- `public_key = file("${var.ssh_public_key_location}")`


###### 4. Terraform configures Security Group module and opens up the firewall
- Add  home/proxy IP addresses under `ingress_with_cidr_blocks`


###### 5. Terraform calls sorrowset_EC2 Module and builds our server
- Could change the `name` `instance_type` `key_name` `monitoring` and `volume` information


###### 5. Terraform runs shell code, updates VM, creates ansible user, adds keys, passwordless sudo
- Change it if you want a different `ansible` user


#### [ _What Ansible's Doing_ ]


###### 1. Ansible kicks off with `deploy.yml` 

- `deploy.yml` Gathers facts and installs the role `requirements.yml` (or optionally installs them to the local path of the project) for the project. It sets variables for the Kasm installation, and kicks off installing those roles in that order.


###### 2. Ansible works the `inventory.yml` 

- Sets the python interpreter, SSH/authorized keys, user/permissions and groups, pip/docker options and timezone to be used as the roles deploy


###### 3. Ansible installs roles

- Ansible starts doing the work installing the roles using the variables set in the inventory.
- weareinteractive.users = Users/Groups/Keys
- geerlingguy.pip, geerlingguy.ntp = Handles pip and NTP
- geerlingguy.security = Mostly SSH security. Auto-updates, fail2ban, etc
- viasite-ansible.zsh = installs zsh
- docker = Checks for Docker, Installs clean with Compose
- os = upgrade, locale, swap partition, etc
- ansible-elasticsearch =
- ansible-traefik =
- ansible-kasm_server =
- ansible-vault =
- darkwizard242.hugo =
- justin_p.gophish =






 

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

###### 2. Make your mods to `main.tf`, `inventory.yml`, `providers.tf`, `variables.tf`

 See above '_What Terraform's Doing_'
 Create a keypair in your .ssh folder called "ansiblekey"
 Open each of those files and Ctrl+f "<<USERNAME>>" and replace with yours. If these changes are made and ansiblekey/ansiblekey.pub exist in your user ssh folder you should be good.
 Ctrl+f for "<<BUCKET>>" and change your "endpoint" "bucket" nad "key" to match your digital ocean space. This will hold your terraform state remotely, you can clone your repo, make changes and apply from any computer without confusing the cloud.


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
code inventory/inventory.yml
ctrl+f and replace "<<OUTPUT FROM TERRAFORM>>"
```

###### 6. Customize first run deployment by comment/uncomment roles under `deploy.yml` 

###### 7. Run the deploy.yml playbook
ansible-galaxy install -r requirements.yml
ansible-playbook deploy.yml



# Cmds

# Export expected keys, since DigitalOcean space is S3 compatible it expects your Space keys in the AWS environment variable format
export AWS_ACCESS_KEY_ID="<<DO SPACE KEY1>>"
export AWS_SECRET_ACCESS_KEY="<<DO SPACE KEY2>>"
export DO_PAT="<<DO ACCESS TOKEN>>"

# Apply with DO_Token exported on CMD line
terraform apply -auto-approve -var "do_token=${DO_PAT}"

# Prep Ansible
ansible-galaxy install --roles-path ~/roles -r requirements.yml
export ANSIBLE_CONFIG=ansible.cfg
vim /inventory/inventory.yml # Add the IP output from terraform
ansible-playbook -i inventory deploy.yml

# Destroy All Resources
terraform destroy -auto-approve -var "do_token=${DO_PAT}"

# Debug
$Env:TF_LOG = "TRACE"
terraform apply 2>&1 | Tee-Object -FilePath apply.txt

## ToDo

- [ ] CICD
- [x] S3 DO Backend (create version without for those who dont want to pay for DO Space)
- [ ] Phishing role
- [ ] Redirector role
- [ ] Figure out wtf with Traefik 

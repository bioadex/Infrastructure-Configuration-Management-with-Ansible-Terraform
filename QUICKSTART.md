# Quick Start Guide

**Get running in 5 minutes.**

---

## Prerequisites

✅ Terraform installed  
✅ Ansible installed  
✅ AWS credentials configured  
✅ Docker Hub account  

**WSL Users:** Project MUST be in `/home/username/` (not `/mnt/c/...`)

---

## Setup

### 1. Bootstrap
```bash
cp bootstrap/terraform.tfvars.example bootstrap/terraform.tfvars
# Edit: Set your unique bucket name

cd bootstrap
terraform init && terraform apply
cd ..
```

### 2. Secrets
```bash
# Create vault
ansible-vault create group_vars/all/vault.yml

# Add:
vault_docker_username: "your-email@example.com"
vault_docker_password: "your-password"

# Save vault password
echo "your-vault-password" > .vault_pass
chmod 600 .vault_pass
```

### 3. Deploy Dev
```bash
cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
# Edit: Set allowed_ssh_cidr = "YOUR_IP/32"

cd environments/dev
terraform init && terraform apply
cd ../..

ansible-playbook -i environments/dev/inventory.ini playbook.yml
```

### 4. Access App
```bash
cd environments/dev
terraform output app_url
# Open URL in browser
```

---

## Deploy Prod

```bash
cp environments/prod/terraform.tfvars.example environments/prod/terraform.tfvars
# Edit: Set your IP

cd environments/prod
terraform init && terraform apply
cd ../..

ansible-playbook -i environments/prod/inventory.ini playbook.yml
```

---

## Cleanup

```bash
cd environments/dev && terraform destroy
cd ../prod && terraform destroy
cd ../../bootstrap && terraform destroy
```

---

## Troubleshooting

**Permission errors (WSL)?** → Move project to `~/` not `/mnt/c/`  
**SSH fails?** → Wait 30 seconds for instance to boot  
**State locked?** → `terraform force-unlock LOCK_ID`

---

**That's it!** See README.md for details.
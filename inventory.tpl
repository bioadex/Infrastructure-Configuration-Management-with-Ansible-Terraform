[appservers]
app ansible_host=${app_ip} ansible_user=ec2-user ansible_ssh_private_key_file=${ssh_key_path} ansible_python_interpreter=/usr/bin/python3

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=accept-new -o ControlMaster=auto -o ControlPersist=60s'
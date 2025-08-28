resource "aws_instance" "BastionHost" {
    ami = var.ami
    instance_type = var.instance_type
    security_groups = [var.bastion_sg]
    subnet_id = var.subnet_id
    key_name = var.key_name
    user_data = <<-EOF
      #!/bin/bash

      # Log everything for debugging
      exec > >(tee -a /var/log/user_data.log | logger -t user_data -s 2>/dev/console) 2>&1
      set -x

      # Wait for the network and IAM
      sleep 10

      OS_TYPE=$(grep -Ei 'ubuntu|amazon linux' /etc/os-release | awk -F= '{print $2}' | tr -d '"')

      # Update and install mysql
      if echo "$OS_TYPE" | grep -q "Amazon Linux"; then
          echo "Detected Amazon Linux 2. Installing AWS CLI v2 and Apache..."
        
          sudo yum update -y
          sudo yum install -y mysql

          #start ssm-agent
          sudo systemctl start amazon-ssm-agent
          sudo systemctl enable amazon-ssm-agent

      elif echo "$OS_TYPE" | grep -q "Ubuntu"; then
          echo "Detected Ubuntu. Installing AWS CLI and Apache..."
        
          sudo apt update -y
          sudo apt install -y mysql-client

          #start ssm-agent
          sudo snap start amazon-ssm-agent
          sudo snap services amazon-ssm-agent

      else
          echo "Unsupported OS. This script supports Amazon Linux 2 and Ubuntu only."
          exit 1
      fi
    EOF
    
    tags = merge(var.default_tags, { Name = var.bastion_tag })  

}

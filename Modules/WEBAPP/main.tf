# EC2
resource "aws_instance" "WebApp" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [var.Web-app-sg]
    subnet_id = var.webapp_subnet
    key_name = var.key_name
    iam_instance_profile = var.iam_instance_profile
    tags = merge(var.default_tags , { Name = var.EC2_webapp_tag })
    user_data = <<-EOF
      #!/bin/bash

      # Log everything for debugging
      exec > >(tee -a /var/log/user_data.log | logger -t user_data -s 2>/dev/console) 2>&1
      set -x

      # Wait for the network and IAM
      sleep 10

      OS_TYPE=$(grep -Ei 'ubuntu|amazon linux' /etc/os-release | awk -F= '{print $2}' | tr -d '"')

      # Update and install ssm-agent
      if echo "$OS_TYPE" | grep -q "Ubuntu"; then
          echo "Detected Ubuntu...."

          #start ssm-agent
          sudo apt update -y
          sudo snap start amazon-ssm-agent
          sudo snap services amazon-ssm-agent


      elif echo "$OS_TYPE" | grep -q "Amazon Linux"; then
          
          #start ssm-agent
          sudo yum update -y
          sudo systemctl start amazon-ssm-agent
          sudo systemctl enable amazon-ssm-agent

      else
          echo "OS not suppurted. This script supports Amazon Linux 2 and Ubuntu only."
          exit 1
      fi
    EOF
    
}
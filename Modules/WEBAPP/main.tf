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

          # download script and execute
          for i in {1..5}; do
            if curl -fsSL -o /tmp/employees.sql https://raw.githubusercontent.com/Carlo-05/CI-CD-Github-Actions-Terraform-Project/refs/heads/main/Other%20Documents/employees.sql; then
                echo "sql file download succeeded"
                break
            else
                echo "Attempt downloading sql file failed, retrying in 10s..."
                sleep 10
            fi
            done

          for i in {1..5}; do
            if curl -fsSL -o /tmp/ci-cd-project.sh https://raw.githubusercontent.com/Carlo-05/CI-CD-Github-Actions-Terraform-Project/refs/heads/main/Other%20Documents/ci-cd-project.sh; then
                echo "script file download succeeded"
                chmod 755 /tmp/ci-cd-project.sh
                /tmp/ci-cd-project.sh
                break
            else
                echo "Attempt downloading script file failed, retrying in 10s..."
                sleep 10
            fi
            done


      elif echo "$OS_TYPE" | grep -q "Amazon Linux"; then
          
          #start ssm-agent
          sudo yum update -y
          sudo systemctl start amazon-ssm-agent
          sudo systemctl enable amazon-ssm-agent


          # download script and execute
          for i in {1..5}; do
            if curl -fsSL -o /tmp/employees.sql https://raw.githubusercontent.com/Carlo-05/CI-CD-Github-Actions-Terraform-Project/refs/heads/main/Other%20Documents/employees.sql; then
                echo "sql file download succeeded"
                break
            else
                echo "Attempt downloading sql file failed, retrying in 10s..."
                sleep 10
            fi
            done

          for i in {1..5}; do
            if curl -fsSL -o /tmp/ci-cd-project.sh https://raw.githubusercontent.com/Carlo-05/CI-CD-Github-Actions-Terraform-Project/refs/heads/main/Other%20Documents/ci-cd-project.sh; then
                echo "script file download succeeded"
                chmod 755 /tmp/ci-cd-project.sh
                /tmp/ci-cd-project.sh
                break
            else
                echo "Attempt downloading script file failed, retrying in 10s..."
                sleep 10
            fi
            done

      else
          echo "OS not suppurted. This script supports Amazon Linux 2 and Ubuntu only."
          exit 1
      fi
    EOF
    

}

locals {
  name_tag = {
    Name = var.Webapp_ASG_tag
  }
  all_tags = merge(var.default_tags, local.name_tag)
  asg_tags = [
    for key, value in local.all_tags : {
      key                 = key
      value               = value
      propagate_at_launch = true
    }
  ]
}


# ASG launch template
resource "aws_launch_template" "WebApp_ASG_template" {
    name = var.WebApp_ASG_template_tag
    image_id = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [ var.ASG_template_sg ]
    iam_instance_profile {
      name = var.iam_instance_profile
    }
    #user data, get sh file from github
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
    
    tags = merge(var.default_tags, {Name = var.WebApp_ASG_template_tag })
}

# ASG policy
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "cpu-target-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.WebApp_ASG.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value       = 50.0 # Target average CPU usage %
    disable_scale_in   = false
  }
}

# ASG
resource "aws_autoscaling_group" "WebApp_ASG" {
    depends_on = [ aws_launch_template.WebApp_ASG_template ]
    name = var.Webapp_ASG_tag
    desired_capacity = 2
    max_size = 4
    min_size = 2
    vpc_zone_identifier = [var.subnet-1, var.subnet-2]
    target_group_arns = var.webapp_target_group

    launch_template {
      id = aws_launch_template.WebApp_ASG_template.id
      version = "$Latest"
    }
    
    dynamic "tag" {
    for_each = local.asg_tags
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
    }
}



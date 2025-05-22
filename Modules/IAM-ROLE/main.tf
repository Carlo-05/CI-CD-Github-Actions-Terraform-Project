# iam role
resource "aws_iam_role" "project_iam_role" {
  name = var.iam_role_tag

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(var.default_tags, { Name = var.iam_role_tag })
}

# iam policy

resource "aws_iam_role_policy_attachment" "ec2_read_only_policy" {
    role = aws_iam_role.project_iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  
}

resource "aws_iam_role_policy_attachment" "rds_full_access_policy" {
    role = aws_iam_role.project_iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  
}

resource "aws_iam_role_policy_attachment" "ssm_instance_core_policy" {
    role = aws_iam_role.project_iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  
}

resource "aws_iam_role_policy_attachment" "cloudwatch_full_access" {
  role       = aws_iam_role.project_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "iam_instance_profile"
  role = aws_iam_role.project_iam_role.name
  
}
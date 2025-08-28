#!/bin/bash

# Create sql file
sudo tee ec2details.sql > /dev/null <<EOF
CREATE TABLE ec2_instances (
    id INT AUTO_INCREMENT PRIMARY KEY,
    instance_id VARCHAR(50) NOT NULL,
    private_ip VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF

# Varibles
SQL_FILE="ec2details.sql"

# Detect OS
OS_TYPE=$(grep -Ei 'ubuntu|amazon linux' /etc/os-release | awk -F= '{print $2}' | tr -d '"')

# Install AWS CLI, Apache, and dependencies
if echo "$OS_TYPE" | grep -q "Amazon Linux"; then
    echo "Detected Amazon Linux 2. Installing AWS CLI v2 and Apache..."
    
    # Update and install Apache
    sudo yum update -y
    sudo yum install -y httpd unzip mysql
    
    # Install AWS CLI v2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    
    # Start & Enable Apache
    sudo systemctl start httpd
    sudo systemctl enable httpd

elif echo "$OS_TYPE" | grep -q "Ubuntu"; then
    echo "Detected Ubuntu. Installing AWS CLI and Apache..."
    
    # Update and install Apache
    sudo apt-get update -y
    sudo apt-get install -y awscli apache2 mysql-client
    
    # Start & Enable Apache
    sudo systemctl start apache2
    sudo systemctl enable apache2

else
    echo "Unsupported OS. This script supports Amazon Linux 2 and Ubuntu only."
    exit 1
fi

# Fetch AWS Metadata
TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)


# Fetch SSM parameters
RDS_ENDPOINT=$(aws ssm get-parameter --name "/projectdb/endpoint" --query "Parameter.Value" --region $REGION --output text)
RDS_USERNAME=$(aws ssm get-parameter --name "/projectdb/username" --query "Parameter.Value" --region $REGION --output text)
RDS_PASSWORD=$(aws ssm get-parameter --name "/projectdb/password" --with-decryption --query "Parameter.Value" --region $REGION --output text)
RDS_DATABASE=$(aws ssm get-parameter --name "/projectdb/database" --query "Parameter.Value" --region $REGION --output text)

# Ensure no port is appended to the endpoint (remove :3306 if it's accidentally added)
RDS_ENDPOINT=$(echo $RDS_ENDPOINT | sed 's/:3306//')

# Validate fetched values
if [[ -z "$RDS_ENDPOINT" || -z "$RDS_USERNAME" || -z "$RDS_PASSWORD" || -z "$RDS_DATABASE" ]]; then
    echo "Error: Failed to retrieve RDS credentials from SSM Parameter Store."
    exit 1
fi

# Check if the table ec2_instances exists
table_exists_ec2instances=$(mysql -h "$RDS_ENDPOINT" -u "$RDS_USERNAME" -p"$RDS_PASSWORD" -D "$RDS_DATABASE" -se "
SHOW TABLES LIKE 'ec2_instances';
")

# Conditional to import $SQL_FILE
if [ -z "$table_exists_ec2instances" ]; then
    echo "Table ec2_instances does not exist. Proceeding with import..."
    mysql -h "$RDS_ENDPOINT" -u "$RDS_USERNAME" -p"$RDS_PASSWORD" "$RDS_DATABASE" < "$SQL_FILE"
    if [ $? -eq 0 ]; then
        echo "Importing $SQL_FILE.....Done!"
        if [ -f $SQL_FILE ]; then
            sudo rm $SQL_FILE
            echo "$SQL_FILE deleted."
        else
            echo "$SQL_FILE not found."
        fi
    else
        echo "Importing failed. Deleting $SQL_FILE aborted."
    fi
elif [ -f $SQL_FILE ]; then
    echo "Table ec2_instances already exist!"
    sudo rm $SQL_FILE
    echo "Deleting $SQL_FILE....Done!"
else
    echo "The table ec2_instances already exist or the file $SQL_FILE not found."
fi

# Insert instance details into MySQL RDS
mysql -h "$RDS_ENDPOINT" -u "$RDS_USERNAME" -p"$RDS_PASSWORD" -D "$RDS_DATABASE" -e "
INSERT INTO ec2_instances (instance_id, private_ip) VALUES ('$INSTANCE_ID', '$PRIVATE_IP');"

# Check if the table employees exists
table_exists_employees=$(mysql -h "$RDS_ENDPOINT" -u "$RDS_USERNAME" -p"$RDS_PASSWORD" -D "$RDS_DATABASE" -se "
SHOW TABLES LIKE 'employees';
")

# Conditional to import employees.sql
if [ -z "$table_exists_employees" ]; then
    echo "Table employees does not exist. Proceeding with import..."
    mysql -h "$RDS_ENDPOINT" -u "$RDS_USERNAME" -p"$RDS_PASSWORD" "$RDS_DATABASE" < employees.sql
    if [ $? -eq 0 ]; then
        echo "Importing employees.sql.....Done!"
        if [ -f employees.sql ]; then
            sudo rm employees.sql
            echo "employees.sql deleted."
        else
            echo "employees.sql not found."
        fi
    else
        echo "Importing failed. Deleting employees.sql aborted."
    fi
elif [ -f employees.sql ]; then
    echo "Table employees already exist!"
    sudo rm employees.sql
    echo "Deleting employees.sql....Done!"
else
    echo "The table employees already exist or the file employees.sql not found!"
fi    

# Create an HTML file with the S3 image as background
sudo tee /var/www/html/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>EC2 Instance Info</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 20%;
            background-color: #f4f4f4;
        }
        .container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>EC2 Instance Info</h1>
        <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
    </div>
</body>
</html>
EOF


# Restart Apache to apply changes
if echo "$OS_TYPE" | grep -q "Amazon Linux"; then
    sudo systemctl restart httpd
else
    sudo systemctl restart apache2
fi


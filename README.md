# **CI-CD-Github-Actions-Terraform-Project**
-	This project provisions a full AWS infrastructure using Infrastructure as Code (IaC) with Terraform and automate deployments through Github Actions . 
    -  **Environment used:**
       -  prod (Production)
       -  dev (Development)
    -  **AWS services used:**
       -  IAM
       -  S3
       -  VPC
       -  EC2
       -  EC2 Auto Scaling Group (ASG)
       -  Relational Database Service (RDS)
       -  SSM Parameters Store
       -  Application Load Balancer (ALB)
       -  NAT Gateway
    -  **.github/workflows(Github Actions)**
       -  **master.yml** - manually manages the main branch pipeline and integrates all stages like check.yml and deploy.yml using workflow_dispatch. This feature allows users to run a workflow on demand directly from the GitHub Actions dashboard. For example, a workflow may require selecting an input such as the **target environment (dev or prod)** before execution. This provides flexibility for operators to control when and how specific CI/CD pipelines are executed, outside of automatic triggers like push or pull_request events.
       -  **check.yml** - checks the format and validate terraform configuration.
       -  **deploy.yml** - terraform provisions aws infrastructure securely using AWS using OIDC authentication.
       -  **destroy.yml** - decommission the aws infrastructure built by deploy.yml safely that was previously provisioned with Terraform. It is manually triggered using workflow_dispatch to ensure that destructive actions are performed only with explicit approval. This workflow runs the terraform destroy command against the specified **environment (dev or prod)**, removing all associated resources in a controlled manner.
#### *Note: Some services may incur costs beyond AWS Free Tier account limits. Please keep this in mind.*
## **Purpose:**
-	To demonstrate:
    - create OpenID Connect (OIDC) which is a secure identity protocol that lets external systems (like GitHub Actions) authenticate with AWS without storing long-lived access keys. Instead, AWS trusts tokens issued by the OIDC provider to grant temporary IAM role credentials.
    - The use of GitHub Actions as a CI/CD platform for infrastructure provisioning.
    - Automated build, test, and deployment pipelines for AWS infrastructure.
    - Best practices in IaC with environment separation, modular Terraform, and secure secret handling.

## **Environment Features:**
-	**Dev**

    -	A lightweight HTML-based web application deployed on an EC2 Auto Scaling Group (ASG) that retrieves Instance ID’s and Private IPs, and logs the data securely into an Amazon RDS Multi-AZ (MySQL) database.
    -   Demonstrate the use of ssm agent to access ec2 and rds content in a local computer.

-	**Prod**

    -	A lightweight HTML-based web application deployed on an EC2 instance that retrieves its Instance ID and Private IP, and logs the data securely into an Amazon RDS (MySQL) database.
    -   Implements a Bastion Host to securely access AWS resources (such as EC2 instances and RDS databases) in isolated subnets. It is capable of ssm agent access as well.
    -   It uses Application Load Balancer (ALB) to manage traffic into your Auto Scaling Group (ASG).
    -   Implements Application Load Balancer (ALB) access logging, configured to store detailed traffic logs in a dedicated Amazon S3 bucket. This enables auditing, monitoring, and performance analysis of incoming requests to your web application.
### _Note:_
-	### AMI id is account specific. Update the AMI values in Github Actions Environment Variables for both the dev and prod environments to prevent deployment issue. For this project, I used ubuntu and linux 2 — ensure that you used the OS mentioned.

## **Architecture diagram**

- **Project overview**
  
    <div align="left">
    <img src="https://github.com/Carlo-05/CI-CD-Github-Actions-Terraform-Project/blob/main/Other%20Documents/Picture/Project%20tree.png?raw=true" alt="Project overview"style="width: 30%; height: auto;">
    </div>


- **Dev:**

    <div align="left">
    <img src="https://github.com/Carlo-05/CI-CD-Github-Actions-Terraform-Project/blob/main/Other%20Documents/Picture/DEV%20SCHEMATIC%20DIAGRAM.png?raw=true" alt="DEV"style="width: 80%; height: auto;">
    </div>
 
- **Prod:**

    <div align="left">
    <img src="https://github.com/Carlo-05/CI-CD-Github-Actions-Terraform-Project/blob/main/Other%20Documents/Picture/PROD%20SCHEMATIC%20DIAGRAM.png?raw=true" alt="PROD"style="width: 80%; height: auto;">
    </div>
 

## **Technologies used**

**GitHub**
-	Used for version control, collaboration, and project hosting.
-	To allow users to clone and explore the project.

**GitHub Actions**
-	A CI/CD and automation tool built into GitHub.
-	Automates workflows triggered by events in your repository.

**Terraform**
-	an open-source "Infrastructure as Code" (IaC) tool, is used to automate the provisioning and management of cloud and on-premises infrastructure by defining infrastructure as code, enabling consistent and repeatable deployments.
-	Terraform documentation used in building this project: 
    https://registry.terraform.io/providers/hashicorp/aws/latest/docs

**AWS**
-	cloud computing service provider which is offered by Amazon
-	cloud services used in this project are VPC, EC2, RDS, Auto Scaling Group (ASG), S3, IAM, and Application Load Balancer (ALB).
-	AWS Command Line Interface (CLI) documentation used in building this project: https://docs.aws.amazon.com/cli/

**Visual Studio Code**
-	is a powerful integrated development environment (IDE) created by Microsoft. It offers features like code editing, debugging, version control integration, and rich extensions, making it a versatile tool for developers of all levels.

**Linux OS**
-	Project development using Terraform on Linux environment.
-	Created several scripts and sql file needed for this project.

**AI Assistance**
-	Used as a learning and development aid for troubleshooting and following best practices in Terraform and AWS infrastructure design.
-	Github Copilot, ChatGPT.

## **Other Files**
**IAM-ROLE-GITHUBACTION(Folder)**
-   Terraform configuration directory that sets up OpenID Connect, a secure identity protocol that lets external systems (like GitHub Actions) authenticate with AWS without storing long-lived access keys.
  
**ci-cd-project.sh**
-   This script runs in EC2 and ASG module.
-	This script dynamically detects whether the OS of the instance is Linux 2 or Ubuntu. It installs necessary system update and dependencies including aws-cli, mysql, and apache.    
-   Creates ec2details.sql which creates ec2_details table into your RDS MySQL.
-   Fetch AWS metadata which includes instance id, instance private ip, region, and token.
-	Fetch RDS MySQL credentials from SSM parameters.
-	Import employees.sql and ec2details.sql into the database using the RDS MySQL credentials.
-	Insert instance id and instance private ip into the MySQL table called ec2_details.
-	Creates index.html that shows the ec2 information like instance id and private ip.

**Employees.sql**
-	Creates employees table and inserts employee’s id, name, and role.


## **Modules Explanation**
**Module** – is a self-contained Terraform module, with well-organized configuration files to 
    manage infrastructure as code.

**ALB**
- Application Load Balancer. Allows http traffic to the WebApp Auto Scaling Group.

**ASG**
-	Auto scaling group. Has a target scaling policy, that will scale out when the average CPU utilization is >= 50%. Furthermore, it scales in when the average CPU utilization is <50%.
-	Download and install necessary dependencies via user data. Start ssm agent as well.

**BASTION**
-	Bastion host instance, is it use to securely connect to the instances and databases without exposing them to public
-	Download and install necessary dependencies via user data. Start ssm agent as well.
	
**WEBAPP**
-	WebApp instance, is displays its own instance id and public ip in a web browser.
-	Download and install necessary dependencies via user data. Start ssm agent as well.
	
**IAM-ROLE**
-	IAM role that is attached to WebApp instance. It has a policy that includes AmazonEC2ReadOnlyAccess, AmazonRDSFullAccess, AmazonSSMManagedInstanceCore, and CloudWatchFullAccess.
	
**KEYPAIR**
-	Create a key pair using the keys generated on your local machine. This process will import your public key into AWS, enabling authentication with the private key stored locally and the corresponding public key in AWS.

**NAT**
-	NAT Gateway, it enables the resources in private subnets to access the internet while preventing inbound traffic from external sources.

**RDS-MYSQL**
-	RDS MySQL database
-	Stores instance id’s, private ips, and employee’s data.

**SECURITYGROUPS**
-	Centralize security group module, where all of the resource’s security group are stored.

**VPC**
-	Our project virtual network infrastructure. Please see picture of dev and prod for reference.

## **How to use:**

- [1. Prerequisites (WSL, VS Code, Terraform, AWS cli setup, and fork this project).](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/1.%20Prerequisites.md)
- [2. First step (create s3, create s3 policy, and create RDS credentials in SSM Parameters Store).](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/2.%20First%20step.md)
- [3. Create OpenID Connect (OIDC) and configure secrets and variables.](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/3.%20How%20to.md)
- [4. Github Actions, Terraform configuration execution and project testing.](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/4.%20ASG%20test.md)
- [5. Test EC2 Auto Scaling Group (ASG).](https://github.com/Carlo-05/Terraform-WebApp-RDS-Vault-Project/blob/main/Other%20documents/md%20files/5.%20MySQL%20verification.md)


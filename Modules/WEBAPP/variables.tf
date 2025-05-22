variable "ami" {
    description = "ami value"
}

variable "instance_type" {
    description = "instance type"  
}
variable "Web-app-sg" {
  description = "webapp sg"
}
variable "webapp_subnet" {
    description = "webapp_subnet"  
}
variable "key_name" {
  description = "web app key pair"
}

variable "iam_instance_profile" {
    description = "iam role for your webapp" 
}

# Tagging

variable "default_tags" {
    type = map(string)
    description = "local tags"
  
}

variable "EC2_webapp_tag" {
    description = "ec2 webapp tag"
  
}
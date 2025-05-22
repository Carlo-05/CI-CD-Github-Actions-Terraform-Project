# Key Pair
resource "aws_key_pair" "wrvp_keypair" {
    key_name = var.keypair_tag
    public_key = file("~/.ssh/id_rsa.pub")
    tags = merge(var.default_tags, { Name = var.keypair_tag } )
  
}



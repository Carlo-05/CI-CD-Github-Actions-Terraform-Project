# Key Pair
resource "aws_key_pair" "wrvp_keypair" {
    key_name = var.keypair_tag
    public_key = var.public_key
    tags = merge(var.default_tags, { Name = var.keypair_tag } )
  
}



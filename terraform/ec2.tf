resource "aws_instance" "tf-import" {
  ami                     = "ami-0567589d25e06853e"
  instance_type           = "t3.micro"

  tags = {
    "Name" = "tf-import"
  }

}

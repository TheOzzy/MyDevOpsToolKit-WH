resource "aws_instance" "this" {
  ami                     = "ami-0e5df6fd7455z77b3"
  instance_type           = "t2.micro"
}

resource "aws_instance" "this" {
  ami                     = "ami-0e5df6fd7455a69b3"
  instance_type           = "t2.micro"
}

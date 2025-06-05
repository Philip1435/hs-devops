resource "aws_key_pair" "main" {
  key_name   = "harbour-space-devops-2025"
  public_key = "~/.ssh/id_ed25519.pub"
}

resource "aws_instance" "main" {
  ami           = "ami-019ec1d173eb71f6a"
  instance_type = "t3.micro"
  key_name = aws_key_pair.main.id

  tags = {
    Name = "HelloWorld"
  }
}

output "IPs" {
    value = aws_instance.main.public_ip
}
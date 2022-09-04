resource "aws_instance" "Demo" {
    ami = "ami-02d1e544b84bf7502"
    instance_type = "t2.micro"
    count = 1
    key_name = "mykeypair"
    security_groups = ["${aws_security_group.web_server.name}"]
    tags = {
      "Name" = "instance-${count.index}"
    }
}
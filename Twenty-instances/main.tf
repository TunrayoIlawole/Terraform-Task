resource "aws_instance" "my-machines" {
  # Creates twenty identical aws ec2 instances
  count = 20     
  
  # All twenty instances will have the same ami and instance_type
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    # The count.index allows you to launch a resource 
    # starting with the distinct index number 0 and corresponding to this instance.
    Name = "my-machine-${count.index}"
  }
}
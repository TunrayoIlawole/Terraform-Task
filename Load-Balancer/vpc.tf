data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "subnet" {
    vpc_id = data.aws_vpc.default.id
    
}

# data "aws_subnets" "subnet" {
#     filter {
#       name = "vpc_id"
#       values = [var.vpc_id]
#     }
# }
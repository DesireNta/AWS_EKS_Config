resource "aws_vpc" "s05_principal" {
   cidr_block = "10.5.0.0/16"

   tags = {
     "Name" = "terraform-eks-s05-node"
   }
 }

 resource "aws_subnet" "s05_subnet" {
   count = 2
   cidr_block        = "10.5.${count.index}.0/24"
   vpc_id            = aws_vpc.s05_principal.id

   tags = {
     "Name" = "terraform-eks-s05-node"
   }
 }

 resource "aws_internet_gateway" "s05_gateway" {
   vpc_id = aws_vpc.s05_principal.id

   tags = {
     Name = "terraform-eks-s05"
   }
 }
 resource "aws_route_table" "s05_route_table" {
   vpc_id = aws_vpc.s05_principal.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.s05_gateway.id
   }
 }

 resource "aws_route_table_association" "s05_route_table_associ" {
   count = 2

   subnet_id      = aws_subnet.s05_subnet[count.index].id
   route_table_id = aws_route_table.s05_route_table.id
 }

provider "aws" {
	region = "ap-south-1"
}

resource "aws_vpc" "myVpc" {
	cidr_block = "10.0.0.0/16"
	
	tags = {
		Name = "CustomVPC"
	}
}

resource "aws_subnet" "mySubnet1" {
		vpc_id = aws_vpc.myVpc.id
		cidr_block = "10.0.1.0/24"
	
		tags = {
			Name = "mySubnet1"
		}
	}

resource "aws_subnet" "mySubnet2" {
		vpc_id = aws_vpc.myVpc.id
		cidr_block = "10.0.2.0/24"
		
		tags = {
			Name = "mySubnet2"
		}
	}
	
resource "aws_internet_gateway" "myIgw" {
	vpc_id = aws_vpc.myVpc.id
	
	tags = {
		Name = "MyinternetGateway"
	}
}

resource "aws_route_table" "Myrt" {
	vpc_id = aws_vpc.myVpc.id 
	route = []
	
	tags = {
		Name = "MyRouteTable"
	}
}

resource "aws_route" "routes" {
	route_table_id = aws_route_table.Myrt.id
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.myIgw.id
	depends_on = [aws_route_table.Myrt]
}

resource "aws_security_group" "mySG" {
	name = "allow traffic"
	description = "Allow all traffic"
	vpc_id = aws_vpc.myVpc.id
	
	ingress = [
		{
			description = "all traffic"
			from_port = "0"
			to_port = "0"
			protocol = "-1"
			cidr_blocks = ["0.0.0.0/0"]
			ipv6_cidr_blocks = null
			prefix_list_ids = null
			security_groups = null
			self = null
		}
	]
	
	egress = [
		{
			description = "all traffic"
			from_port = "0"
			to_port = "0"
			protocol = "-1"
			cidr_blocks = ["0.0.0.0/0"]
			ipv6_cidr_blocks = ["::/0"]
			prefix_list_ids = null
			security_groups = null
			self = null
		}
	]
	
	tags = {
		Name = "Security Group"
	}
}

resource "aws_route_table_association" "rTA1" {
	subnet_id = aws_subnet.mySubnet1.id
	#subnet_id = aws_subnet.mySubnet2.id
	route_table_id = aws_route_table.Myrt.id
}

resource "aws_route_table_association" "rTA2" {
	#subnet_id = aws_subnet.mySubnet1.id
	subnet_id = aws_subnet.mySubnet2.id
	route_table_id = aws_route_table.Myrt.id
}

resource "aws_key_pair" "Key1" {
  key_name   = "first-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCEsuGEhHS2etQgiQeHAjRDldo3OF0EdVLtNNciKjl4ThdV16RlqSF9po8q93+adUpdx1FRQ544DPAf6QochQGVCy4iZo+VS7HxBV9nJqWHmT7dXqv5tU7o9I65gB0uS3pL/CQMB9Iwa80qVkU1+CMzkX4JNKI3nPAwiZ6LmVy86J/YYpeoJNkYM1u4ySR4h3fcL8PZLS5bSrsHyxWILSaauTwXZZqQKWMHqIrupDqfhsloAxGp/Kc6vPRbVqjtdSuvw+YroXgD74MvhsxsZqJ7i9PoDFg3IdjPeC8qDtcbAt3oF9Az+Ju6HatcbI0bMSKiFeofsqi6s6kGxAgC0TT7 Mumbai"
}

resource "aws_key_pair" "Key2" {
	key_name = "second-key"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCEsuGEhHS2etQgiQeHAjRDldo3OF0EdVLtNNciKjl4ThdV16RlqSF9po8q93+adUpdx1FRQ544DPAf6QochQGVCy4iZo+VS7HxBV9nJqWHmT7dXqv5tU7o9I65gB0uS3pL/CQMB9Iwa80qVkU1+CMzkX4JNKI3nPAwiZ6LmVy86J/YYpeoJNkYM1u4ySR4h3fcL8PZLS5bSrsHyxWILSaauTwXZZqQKWMHqIrupDqfhsloAxGp/Kc6vPRbVqjtdSuvw+YroXgD74MvhsxsZqJ7i9PoDFg3IdjPeC8qDtcbAt3oF9Az+Ju6HatcbI0bMSKiFeofsqi6s6kGxAgC0TT7 Mumbai"
}

resource "aws_instance" "EC2_1"{
	ami = "ami-079b5e5b3971bd10d"
	instance_type = "t2.micro"
	subnet_id = aws_subnet.mySubnet1.id
	key_name = "Mumbai"
	tags = {
		Name = "First_instance"
	}
}

resource "aws_instance" "EC2_2"{
	ami = "ami-079b5e5b3971bd10d"
	instance_type = "t2.micro"
	subnet_id = aws_subnet.mySubnet2.id
	key_name = "Mumbai"
	tags = {
		Name = "Second_instance"
	}
}


resource "aws_vpc" "vpc-for-dev" {
	cidr_block = var.vpc_cidr
	tags = {
		Name = "dev-vpc"
	}
}

resource "aws_subnet" "publicsub-for-dev" {
	vpc_id = aws_vpc.vpc-for-dev.id
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = var.availability_zone
	tags = {
		Name = "dev-publicsub"
	}
}

resource "aws_internet_gateway" "igw-for-dev" {
	vpc_id = aws_vpc.vpc-for-dev.id
	tags = {
		Name = "dev-igw"
	}
}

resource "aws_route_table" "routetable-for-dev" {
	vpc_id = aws_vpc.vpc-for-dev.id
	route {
	cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.igw-for-dev.id
	}
	tags = {
		Name = "dev-crt"
	}
}

resource "aws_route_table_association" "crt-public-for-dev" {
	subnet_id = aws_subnet.publicsub-for-dev.id
	route_table_id = aws_route_table.routetable-for-dev.id
}

resource "aws_security_group" "sg-for-dev" {
	vpc_id = aws_vpc.vpc-for-dev.id
	egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
	ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
	tags = {
		Name = "dev-sg"
	}
}

resource "aws_instance" "instance-for-dev" {
	subnet_id = aws_subnet.publicsub-for-dev.id	
	vpc_security_group_ids = [aws_security_group.sg-for-dev.id]
	instance_type = "t2.micro"
	ami = "ami-0c1a7f89451184c8b"
	key_name = "terraform"
	tags = {
		Name = "dev-app"
	}
	
	connection {
		type = "ssh"
		user = "ubuntu"
		private_key = file("./terraform.pem")
		host = aws_instance.instance-for-dev.public_ip
	}
	
	provisioner "file" {
		source = "./get-docker.sh"
		destination = "/home/ubuntu/get-docker.sh"
	}
	
	provisioner "remote-exec" {
		inline = [
			"chmod +x /home/ubuntu/get-docker.sh",
			"sh /home/ubuntu/get-docker.sh"
		]
	}
	
}


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
		private_key = "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAojsF9KyMjyVEn+8EAh8+e0AUUk1sr4ZFeEF4iE8PJwvknn18
9Xqeiwfh+gPs6RNi/3e+Wfx87iH3IcG6u/Jd9EvOSr7fOCJxY8gmpUJoLi13XDzV
9mWl3Yzc35vKlfrFwrdIdEtc76FxHnNm/FTAfzojsjXn5349nkXZnONw6KprJ8Dd
d1muPCx8YYHvje44uFBR19uDbd2e6eTourgFX1CsF0fgb68h47jzAAJh7UbJUEvG
GcMxkXbYY2FlPOtxjshSULcPrYnTMu12McP7mPbPEXLhsK9xqoZ1ZG5z+x4sTbNL
kFaBfhym1zdHVvoSgQGD6iJCtJuOsiK2unWuNQIDAQABAoIBAFgfNZH9dHCBLvCt
NYEtlZP/b8pxEhuaFPxIm/926mUsWagZxBnX3GzrAD39id/lTv4z/isFMptrycEF
abiT46NC1jDV04y7cNphq1RTaSHEQrTQuuyXtGxPCt9P0dB8IpYtVucM1NO53ydK
SmPAabvySdeQ3oJpmXDywk0tYnSO15Lp7W4Xa86RItIo08JM1wCIwAfejcTqynxN
IW7u8u0dF4WAdRY5gL7AJwVhh6GAVydsdS+FB5o1lxKdky+wl+oFqyqX+Nxzef8E
C/NsOmJlLZyIs8UpXrWReJepJTuEZJrypy4OtJrfb8ZRaJR2uETXbrz8ILjb7QNj
OGLejyECgYEA29o7R1lz55KLpTa6ouEDWF9cJ/e7dqnCdXoy3EHzYQZaKhaofrpR
MGnq01lFrYT4eWG4rp9Fi+PcCiRQVey8ns5lg6YipY631hxtAhNk6BUA4N/U+V63
jnu70jzBTK+/2fWiX7lPI1miT8Ly4ZRiw8KIvU54aeJxdy6Niy3yKCkCgYEAvOdw
Xq35frx2ZSmlE73gk4zA/KGQi2vm3ySqRuSIbHxX8436/H6Sp7MGwY7B9h7a5U88
BffRVm+66ZJM3t02HF0QXalmPmFhNKLwTHwHSYu3R9Hp9adXZRXWNPLdsehP6rHR
WZn9lxI4FwzlFf0pTF/EAZDZTcsXPp4YUzjfhy0CgYEAuKHXcp4fBnU9rWv+5VbO
tmKvRCl6V7dNRddv6yW/vNXW1s3ch0D1ehEZUpEAQS8QdO+qZ4v+nfKoEiRZCzAb
X8q52gulwR/QJ5ILwdiDv5wT9sZDV4FB6fjjzTWUqFBYcDUnPfikC231L8LqsqMp
Jnmy2DiUS2gOHicMW7wkR7ECgYEAt3ZK8xkiA41DqzJL6aVyU7rSv0imWlHcMoGo
ght3x2zn+lm9FbZT9lzvxdJA3CjRTP2r/NvWyozOygPVdmj/IYLc3yoja5gl0Poi
SRX3+dygjzb2cycnwLv5gwkQeLV30CcMfGoLGMqQAQr7/mQV1N/5O9ASy/PfSmg+
lazZoq0CgYEAj4kTrI/RKY6gQldarE0tEBULRgnJUKjUcN3E/wqsadApMwCWPyqf
3DeVPyr3IRwNLinB0mcxdPW4rIILqQB/lcnProiLoEVesxR7MSKu26vHDEzuZIZX
53eKJEIIwXdIH3GZeRCyP/ZOUD+6NrksrPKjFnxjJtbOoePneqfKKDc=
-----END RSA PRIVATE KEY-----"
		host = aws_instance.instance-for-dev.public_ip
	}
	
/*	provisioner "file" {
		source = "./get-docker.sh"
		destination = "/home/ubuntu/get-docker.sh"
	}*/
	
	provisioner "remote-exec" {
		inline = [
			"touch f1 f2 f3"
		]
	}
	
}


resource "aws_vpc" "cloud_vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = "cloud-vpc"
  }
}

# Create Public Subnet
resource "aws_subnet" "cloud_pub_sub" {
  count             = var.pub-sub-count
  vpc_id            = aws_vpc.cloud_vpc.id
  cidr_block        = cidrsubnet(var.vpc-cidr, 8, 10 + count.index)
  availability_zone = var.availability-zone[count.index % length(var.availability-zone)]
  tags = {
    Name = "cloud-pub-sub-${count.index + 1}"
  }
}
resource "aws_subnet" "cloud_pvt_app_sub" {
  count             = var.pvt-app-count
  vpc_id            = aws_vpc.cloud_vpc.id
  cidr_block        = cidrsubnet(var.vpc-cidr, 8, 20 + count.index)
  availability_zone = var.availability-zone[count.index]
  tags = {
    Name = "cloud-pvt-sub-${count.index + 1}"
  }
}

resource "aws_subnet" "cloud_pvt_db_sub" {
  count             = var.pvt-db-count
  vpc_id            = aws_vpc.cloud_vpc.id
  cidr_block        = cidrsubnet(var.vpc-cidr, 8, 30 + count.index)
  availability_zone = var.availability-zone[count.index]
  tags = {
    Name = "cloud-pvt-db-sub-${count.index + 1}"
  }
}


#subnet Group
resource "aws_db_subnet_group" "db_sub_gp" {
  name        = "db-subnet-group"
  description = "DB subnet group"
  subnet_ids  = [aws_subnet.cloud_pvt_db_sub[0].id, aws_subnet.cloud_pvt_db_sub[1].id] # 사용할 서브넷 ID를 지정합니다.
}


# Create Internet Gatway
resource "aws_internet_gateway" "cloud_igw" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name = "cloud-igw"
  }
}

# Create a Public Route table
resource "aws_route_table" "cloud_pub_rtb" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name = "cloud-pub-rtb"
  }
}

# Create a Private Route table
resource "aws_route_table" "cloud_pvt_app_rtb" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name = "cloud-pvt-app-rtb"
  }
}

resource "aws_route_table" "cloud_pvt_db_rtb" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name = "cloud-pvt-db-rtb"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "cloud-pub-rtb-assc" {
  count          = var.pub-sub-count
  subnet_id      = aws_subnet.cloud_pub_sub[count.index].id
  route_table_id = aws_route_table.cloud_pub_rtb.id
}


# Private Route Table Association
resource "aws_route_table_association" "cloud-pvt-app-rtb-assc" {
  count          = var.pvt-app-count
  subnet_id      = aws_subnet.cloud_pvt_app_sub[count.index].id
  route_table_id = aws_route_table.cloud_pvt_app_rtb.id
}


resource "aws_route_table_association" "cloud-pvt-db-rtb-assc" {
  count          = var.pvt-db-count
  subnet_id      = aws_subnet.cloud_pvt_db_sub[count.index].id
  route_table_id = aws_route_table.cloud_pvt_db_rtb.id
}


# Create a EIP
resource "aws_eip" "cloud_ngw_eip" {
  domain = "vpc"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "cloud-ngw-eip"
  }
}

# Create NAT Gatway
resource "aws_nat_gateway" "cloud_ngw" {
  allocation_id = aws_eip.cloud_ngw_eip.id
  subnet_id     = aws_subnet.cloud_pub_sub[0].id
  tags = {
    Name = "cloud-ngw"
  }
}

# Associate Public Subnet with Internet Gateway
resource "aws_route" "cloud_pub_route" {
  route_table_id         = aws_route_table.cloud_pub_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cloud_igw.id
}

# Associate Private Subnets with NAT Gateway
resource "aws_route" "cloud-pvt-app-route" {
  route_table_id         = aws_route_table.cloud_pvt_app_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.cloud_ngw.id
}

resource "aws_route" "cloud-pvt-db-route" {
  route_table_id         = aws_route_table.cloud_pvt_db_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.cloud_ngw.id
}

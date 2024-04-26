resource "aws_vpc" "cloud_vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "cloud_pub_sub" {
  count             = length(var.availability-zone)
  vpc_id            = aws_vpc.cloud_vpc.id
  cidr_block        = cidrsubnet(var.vpc-cidr, 8, 10 + count.index)
  availability_zone = var.availability-zone[count.index % length(var.availability-zone)]
  tags = {
    Name = "${var.env}-pub-sub-${count.index + 1}"
  }
}

# Private Subnet
resource "aws_subnet" "cloud_pvt_sub_1tier" {
  count             = length(var.availability-zone) * var.tier-usage-status-list[0]
  vpc_id            = aws_vpc.cloud_vpc.id
  cidr_block        = cidrsubnet(var.vpc-cidr, 8, 20 + count.index)
  availability_zone = var.availability-zone[count.index]
  tags = {
    Name = "${var.env}-pvt-1tier-${count.index + 1}"
  }
}

resource "aws_subnet" "cloud_pvt_sub_2tier" {
  count             = length(var.availability-zone) * var.tier-usage-status-list[1]
  vpc_id            = aws_vpc.cloud_vpc.id
  cidr_block        = cidrsubnet(var.vpc-cidr, 8, 30 + count.index)
  availability_zone = var.availability-zone[count.index]
  tags = {
    Name = "${var.env}-pvt-2tier-${count.index + 1}"
  }
}

resource "aws_subnet" "cloud_pvt_sub_3tier" {
  count             = length(var.availability-zone) * var.tier-usage-status-list[2]
  vpc_id            = aws_vpc.cloud_vpc.id
  cidr_block        = cidrsubnet(var.vpc-cidr, 8, 40 + count.index)
  availability_zone = var.availability-zone[count.index]
  tags = {
    Name = "${var.env}-pvt-3tier-${count.index + 1}"
  }
}

# Create Internet Gatway
resource "aws_internet_gateway" "cloud_igw" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name = "${var.env}-igw"
  }
}

# Create a Public Route table
resource "aws_route_table" "cloud_pub_rtb" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name = "${var.env}-pub-rtb"
  }
}

# Create a Private Route table
resource "aws_route_table" "cloud_pvt_rtb_1tier" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name = "${var.env}-pvt-rtb-1tier"
  }
}

resource "aws_route_table" "cloud_pvt_rtb_2tier" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name = "${var.env}-pvt-rtb-2tier"
  }
}

resource "aws_route_table" "cloud_pvt_rtb_3tier" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name = "${var.env}-pvt-rtb-3tier"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "cloud_pub_rtb_assc" {
  count          = length(aws_subnet.cloud_pub_sub)
  subnet_id      = aws_subnet.cloud_pub_sub[count.index].id
  route_table_id = aws_route_table.cloud_pub_rtb.id
}


# Private Route Table Association
resource "aws_route_table_association" "cloud_pvt_rtb_assc_1tier" {
  count          = length(aws_subnet.cloud_pvt_sub_1tier)
  subnet_id      = aws_subnet.cloud_pvt_sub_1tier[count.index].id
  route_table_id = aws_route_table.cloud_pvt_rtb_1tier.id
}

resource "aws_route_table_association" "cloud_pvt_rtb_assc_2tier" {
  count          = length(aws_subnet.cloud_pvt_sub_2tier)
  subnet_id      = aws_subnet.cloud_pvt_sub_2tier[count.index].id
  route_table_id = aws_route_table.cloud_pvt_rtb_2tier.id
}

resource "aws_route_table_association" "cloud_pvt_rtb_assc_3tier" {
  count          = length(aws_subnet.cloud_pvt_sub_3tier)
  subnet_id      = aws_subnet.cloud_pvt_sub_3tier[count.index].id
  route_table_id = aws_route_table.cloud_pvt_rtb_3tier.id
}

# Create a EIP
resource "aws_eip" "cloud_ngw_eip" {
  domain = "vpc"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.env}-ngw-eip"
  }
}

# Create NAT Gatway
resource "aws_nat_gateway" "cloud_ngw" {
  allocation_id = aws_eip.cloud_ngw_eip.id
  subnet_id     = aws_subnet.cloud_pub_sub[0].id
  tags = {
    Name = "${var.env}-ngw"
  }
}

# Associate Public Subnet with Internet Gateway
resource "aws_route" "cloud_pub_route" {
  route_table_id         = aws_route_table.cloud_pub_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cloud_igw.id
}

# Associate Private Subnets with NAT Gateway
resource "aws_route" "cloud-pvt-1tier-route" {
  route_table_id         = aws_route_table.cloud_pvt_rtb_1tier.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.cloud_ngw.id
}

resource "aws_route" "cloud-pvt-2tier-route" {
  route_table_id         = aws_route_table.cloud_pvt_rtb_2tier.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.cloud_ngw.id
}

resource "aws_route" "cloud-pvt-3tier-route" {
  route_table_id         = aws_route_table.cloud_pvt_rtb_3tier.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.cloud_ngw.id
}

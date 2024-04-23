# Customer Gateway
resource "aws_customer_gateway" "onprem_openswan" {
  bgp_asn    = "65000"
  ip_address = var.my-ip
  type       = "ipsec.1"

  tags = {
    Name = "onprem-openswan"
  }
}

# Virtual Gateway
resource "aws_vpn_gateway" "cloud_vgw" {
  vpc_id = var.vpc-id

  tags = {
    Name = "cloud-vgw"
  }
}

resource "aws_vpn_gateway_attachment" "cloud_vgw_att" {
  vpc_id         = var.vpc-id
  vpn_gateway_id = aws_vpn_gateway.cloud_vgw.id
}

resource "aws_vpn_gateway_route_propagation" "cloud_vgw_prop" {
  depends_on     = [aws_vpn_gateway_attachment.cloud_vgw_att]
  route_table_id = var.pub-rtb-id
  vpn_gateway_id = aws_vpn_gateway.cloud_vgw.id
}

# VPN Connection
resource "aws_vpn_connection" "cloud-onprem-vpn" {
  customer_gateway_id = aws_customer_gateway.onprem_openswan.id
  vpn_gateway_id      = aws_vpn_gateway.cloud_vgw.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "cloud-onprem-vpn"
  }
}

resource "aws_vpn_connection_route" "cloud-onprem-vpn-route" {
  vpn_connection_id      = aws_vpn_connection.cloud-onprem-vpn.id
  destination_cidr_block = var.onprem-cidr-block
}

output "vpc-id" {
  value = aws_vpc.cloud_vpc.id
}

output "pub-sub" {
  value = aws_subnet.cloud_pub_sub
}

output "pvt-sub-list" {
  value = [aws_subnet.cloud_pvt_sub_1tier[0], aws_subnet.cloud_pvt_sub_2tier[0]]
}

# For VPN
output "pub-route" {
  value = aws_route.cloud_pub_route
}

output "pub-rtb-id" {
  value = aws_route_table.cloud_pub_rtb.id
}

output "vpc-id" {
  value = aws_vpc.cloud_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_sub_gp
}

output "pub-sub-id" {
  value = aws_subnet.cloud_pub_sub.id
}

output "pub-route" {
  value = aws_route.cloud_pub_route
}

output "pub-rtb-id" {
  value = aws_route_table.cloud_pub_rtb.id
}

output "cloud-pvt-app-sub-cidr" {
  value = aws_subnet.cloud_pvt_app_sub.cidr_block
}

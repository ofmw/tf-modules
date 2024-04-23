output "k8s-master-instance" {
  value = aws_instance.k8s_master
}

output "k8s-node-sg" {
  value = aws_security_group.k8s_node_sg
}

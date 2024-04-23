output "grafana-server-id" {
  value = aws_instance.grafana_server.id
}

output "k8s-master-id" {
  value = aws_instance.k8s_master.id
}

output "k8s-node-sg" {
  value = aws_security_group.k8s_node_sg
}

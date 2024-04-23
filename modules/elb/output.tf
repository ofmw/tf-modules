output "k8s-service-tg-80" {
  value = aws_lb_target_group.k8s-service-tg-80.arn
}

output "k8s-grafana-tg-3000" {
  value = aws_lb_target_group.k8s-grafana-tg-3000
}

output "k8s-prometheus-tg-9090" {
  value = aws_lb_target_group.k8s-prometheus-tg-9090
}

output "k8s-monitor-alb-id" {
  value = aws_lb.k8s_monitor_alb.id
}

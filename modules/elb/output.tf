output "k8s-service-tg-80" {
  value = aws_lb_target_group.k8s_service_tg_80
}

output "k8s-grafana-tg-3000" {
  value = aws_lb_target_group.k8s_grafana_tg_3000
}

output "k8s-prometheus-tg-9090" {
  value = aws_lb_target_group.k8s_prometheus_tg_9090
}

output "k8s-monitor-alb-id" {
  value = aws_lb.k8s_monitor_alb.id
}

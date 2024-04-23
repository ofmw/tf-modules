module "provider" {
  source = "./modules/provider"
}

module "vpc" {
  source            = "./modules/vpc"
  vpc-cidr          = var.vpc-cidr
  availability-zone = var.availability-zone
  pub-sub-count     = var.pub-sub-count
  pvt-app-count     = var.pvt-app-count
  pvt-db-count      = var.pvt-db-count
}

module "instance" {
  # count = 1 or 0
  source             = "./modules/instance"
  vpc-id             = module.vpc.vpc-id
  pub-sub-cidr       = module.vpc.pub-sub-id[*]
  pvt-sub-app-cidr   = module.vpc.pvt-app-sub-id[*]
  key-name           = var.key-name
  bastion-ami        = var.bastion-ami
  bastion-type       = var.bastion-type
  grafana-depends-on = module.elb.k8s-grafana-tg-3000
  grafana-ami        = var.grafana-ami
  grafana-type       = var.grafana-type
  my-ip              = var.my-ip
}

module "k8s" {
  count                  = 1
  source                 = "./modules/k8s(no eks)"
  vpc-id                 = module.vpc.vpc-id
  pub-sub-cidr           = module.vpc.pub-sub-id[*]
  pvt-sub-app-cidr       = module.vpc.pvt-app-sub-id[*]
  key-name               = var.key-name
  k8s-master-depends-on  = module.elb.k8s-prometheus-tg-9090
  k8s-master-ami         = var.k8s-master-ami
  k8s-master-type        = var.k8s-master-type
  k8s-master-pvt-ip      = var.k8s-master-pvt-ip
  k8s-node-ami           = var.k8s-node-ami
  k8s-node-type          = var.k8s-node-type
  k8s-node-asg-min       = var.k8s-node-asg-min
  k8s-node-asg-max       = var.k8s-node-asg-max
  k8s-node-asg-desired   = var.k8s-node-asg-desired
  k8s-service-tg-80      = module.elb.k8s-service-tg-80
  k8s-monitor-alb-id     = module.elb.k8s-monitor-alb-id
  pvt-app-sub-cidr-block = module.vpc.cloud-pvt-app-sub-cidr[0]
}

module "elb" {
  count             = 0
  source            = "./modules/elb"
  vpc-id            = module.vpc.vpc-id
  pub-sub-id        = module.vpc.pub-sub-id
  grafana-server-id = module.instance.grafana-server-id
  k8s-master-id     = module.instance.k8s-master-id
}

module "rds" {
  source               = "./modules/rds"
  vpc-id               = module.vpc.id
  availability-zone    = var.availability-zone
  db-subnet-group-name = module.vpc.db_subnet_group_name
  k8s-node-sg          = module.instance.k8s-node-sg
  db-instance-class    = var.instance-class
}

module "route53" {
  source         = "./modules/route53"
  zone-name      = var.zone-name
  record-name    = var.record-name
  record-type    = var.record-type
  record-ttl     = var.record-ttl
  record-records = module.cloudfront.cloudfront-domain-name
}

module "waf" {
  source = "./modules/waf"
}

module "cloudfront" {
  source         = "./modules/cloudfront"
  s3-domain-name = module.s3.s3-domain-name
  s3-id          = module.s3.s3-id
  web-acl-arn    = module.waf.web-acl-arn
}

module "s3" {
  source      = "./modules/s3"
  bucket-name = var.bucket-name
}

module "vpn" {
  source              = "./modules/vpn"
  vpc-id              = module.vpc.vpc-id
  vgw-prop-depends-on = module.vpc.pub-route
  pub-rtb-id          = module.vpc.pub-rtb-id
  my-ip               = var.my-ip
  onprem-cidr-block   = var.onprem-cidr-block

}

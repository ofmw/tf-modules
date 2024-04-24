module "provider" {
  source = "./modules/provider"
}

module "vpc" {
  source                 = "./modules/vpc"
  vpc-cidr               = var.vpc-cidr
  availability-zone      = var.availability-zone
  tier-usage-status-list = var.tier-usage-status-list
}

module "instance" {
  # count = 1 or 0
  source                 = "./modules/instance"
  env                    = var.env
  naming                 = var.naming
  instance-count         = var.instance-count
  instance-ami-list      = var.instance-ami-list
  instance-type-list     = var.instance-type-list
  instance-sub-id-list   = module.vpc.pvt-sub-list[*].id
  instance-key-name-list = var.instance-key-name-list
  vpc-id                 = module.vpc.vpc-id
  availability-zone      = var.availability-zone
  my-ip                  = var.my-ip
}

module "k8s" {
  count                = 1
  source               = "./modules/k8s(no eks)"
  vpc-id               = module.vpc.vpc-id
  pvt-sub-ids          = module.vpc.pvt-sub-list[*].id
  pvt-sub-cidr-blocks  = module.vpc.pvt-sub-list[*].cidr_block
  k8s-key-name         = var.k8s-key-name
  k8s-master-ami       = var.k8s-master-ami
  k8s-master-type      = var.k8s-master-type
  k8s-node-ami         = var.k8s-node-ami
  k8s-node-type        = var.k8s-node-type
  k8s-node-asg-min     = var.k8s-node-asg-min
  k8s-node-asg-max     = var.k8s-node-asg-max
  k8s-node-asg-desired = var.k8s-node-asg-desired
  k8s-service-tg-80    = module.elb.k8s-service-tg-80.arn
}

module "elb" {
  source            = "./modules/elb"
  vpc-id            = module.vpc.vpc-id
  pub-sub-ids       = module.vpc.pub-sub[*].id
  grafana-server-id = module.instance.ec2-instances[1].id
  k8s-master-id     = module.k8s[0].k8s-master-instance.id
}

module "rds" {
  source            = "./modules/rds"
  vpc-id            = module.vpc.vpc-id
  availability-zone = var.availability-zone
  k8s-node-sg-id    = module.k8s[0].k8s-node-sg.id
  db-instance-class = var.instance-class
  subnet-ids        = module.vpc.pvt-sub-list[1][*].id
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
  count             = 1
  depends_on        = [module.vpc]
  source            = "./modules/vpn"
  vpc-id            = module.vpc.vpc-id
  pub-rtb-id        = module.vpc.pub-rtb-id
  my-ip             = var.my-ip
  onprem-cidr-block = var.onprem-cidr-block

}

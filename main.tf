module "provider" {
  source = "./modules/provider"
  region = var.region
}

module "vpc" {
  source                 = "./modules/vpc"
  env                    = var.env
  vpc-cidr               = var.vpc-cidr
  availability-zone      = var.availability-zone
  tier-usage-status-list = var.tier-usage-status-list
}

module "instance" {
  # count = 1 or 0
  source                     = "./modules/instance"
  env                        = var.env
  instance-count             = var.instance-count
  instance-ami-list          = var.instance-ami-list
  instance-type-list         = var.instance-type-list
  instance-sub-id-list       = module.vpc.instance-sub-list[*].id
  instance-key-name-list     = var.instance-key-name-list
  instance-pub-ip-usage-list = var.instance-pub-ip-usage-list
  instance-name-list         = var.instance-name-list
  vpc-id                     = module.vpc.vpc-id
  availability-zone          = var.availability-zone
  my-ip                      = var.my-ip
}

module "k8s" {
  count                = 1
  source               = "./modules/k8s(no eks)"
  env                  = var.env
  vpc-id               = module.vpc.vpc-id
  pvt-sub-ids          = module.vpc.pvt-sub-list[0][*].id
  pvt-sub-cidr-blocks  = module.vpc.pvt-sub-list[0][*].cidr_block
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
  env               = var.env
  vpc-id            = module.vpc.vpc-id
  pub-sub-ids       = module.vpc.pub-sub[*].id
  grafana-server-id = module.instance.ec2-instances[2].id
  k8s-master-id     = module.k8s[0].k8s-master-instance.id
}

module "rds" {
  source            = "./modules/rds"
  env               = var.env
  vpc-id            = module.vpc.vpc-id
  availability-zone = var.availability-zone
  k8s-node-sg-id    = module.k8s[0].k8s-node-sg.id
  db-instance-class = var.instance-class
  subnet-ids        = module.vpc.pvt-sub-list[1][*].id
}

module "route53" {
  source         = "./modules/route53"
  zone-id        = var.zone-id
  record-name    = var.record-name
  record-type    = var.record-type
  record-ttl     = var.record-ttl
  record-records = module.cloudfront.cloudfront-domain-name
}

module "waf" {
  source = "./modules/waf"
  env    = var.env
}

module "cloudfront" {
  source         = "./modules/cloudfront"
  s3-domain-name = module.s3.s3-domain-name
  s3-id          = module.s3.s3-id
  web-acl-arn    = module.waf.web-acl-arn
}

module "s3" {
  source      = "./modules/s3"
  env         = var.env
  bucket-name = var.bucket-name
}

module "vpn" {
  count             = 0
  depends_on        = [module.vpc]
  source            = "./modules/vpn"
  env               = var.env
  vpc-id            = module.vpc.vpc-id
  pub-rtb-id        = module.vpc.pub-rtb-id
  my-ip             = var.my-ip
  onprem-cidr-block = var.onprem-cidr-block
}

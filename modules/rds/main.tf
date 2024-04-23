resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = var.vpc-id


  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.k8s-node-sg
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

#subnet Group
resource "aws_db_subnet_group" "db_sbg" {
  name        = "db-subnet-group"
  description = "DB subnet group"
  subnet_ids  = [aws_subnet.cloud_pvt_db_sub[0].id, aws_subnet.cloud_pvt_db_sub[1].id] # 사용할 서브넷 ID를 지정합니다.
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier      = "example-aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.4"
  availability_zones      = var.availability-zone
  database_name           = "exampledb"
  master_username         = "admin"
  master_password         = "admin123"
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = var.db-subnet-group-name
  vpc_security_group_ids  = [aws_security_group.rds_sg]
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "example_instance" {
  identifier         = "example-aurora-instance"
  cluster_identifier = aws_rds_cluster.rds_cluster.id
  instance_class     = var.db-instance-class
  engine             = aws_rds_cluster.rds_cluster.engine
}

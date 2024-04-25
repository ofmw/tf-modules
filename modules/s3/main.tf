resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket-name

  tags = {
    Name = "${var.env}-${var.bucket-name}"
  }
}

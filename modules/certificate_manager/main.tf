resource "aws_acm_certificate" "this" {
  domain_name        = "domain.com"
  validation_method  = "DNS"

  tags = {
    Name = "certificate"
  }
}

resource "aws_wafv2_web_acl" "waf" {
  name        = "${var.env}-managed-acfp"
  description = "Example of a managed ACFP rule."
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "${var.env}-acfp-rule-1"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesACFPRuleSet"
        vendor_name = "AWS"

        managed_rule_group_configs {
          aws_managed_rules_acfp_rule_set {
            creation_path          = "/signin"
            registration_page_path = "/register"

            request_inspection {
              email_field {
                identifier = "/email"
              }

              password_field {
                identifier = "/password"
              }

              payload_type = "JSON"

              username_field {
                identifier = "/username"
              }
            }

            response_inspection {
              status_code {
                failure_codes = ["403"]
                success_codes = ["200"]
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${var.env}-friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.env}-friendly-metric-name"
    sampled_requests_enabled   = false
  }
}

locals {
  buckets = {
    asdf-crazy-berlin-weather-hourly = {
      rule_name = "expiration-in-7-days",
      days      = 7
    },
    asdf-crazy-berlin-weather-daily = {
      rule_name = "expiration-in-30-days",
      days      = 30
    },
    asdf-crazy-berlin-weather-weekly = {
      rule_name = "expiration-in-120-days",
      days      = 120
    }
  }
}

module "s3" {
  source   = "github.com/wmaramos/terraform-aws-s3-module?ref=v0.1.0"
  for_each = local.buckets

  bucket_name = each.key
  acl         = "private"

  lifecycle_rule = [
    {
      rule_name = each.value.rule_name
      enabled   = true

      expiration = {
        days = each.value.days
      }
    }
  ]
}
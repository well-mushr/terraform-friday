locals {
  buckets = {
    asdf-crazy-berlin-weather-hourly = {
      lifecycle_rule = [
        {
          rule_name = "expiration-in-7-days"
          enabled   = true

          expiration = {
            days = 7
          }
        }
      ]
    },
    asdf-crazy-berlin-weather-daily = {
      lifecycle_rule = [
        {
          rule_name = "expiration-in-30-days"
          enabled   = true

          expiration = {
            days = 30
          }
        }
      ]
    },
    asdf-crazy-berlin-weather-weekly = {
      lifecycle_rule = [
        {
          rule_name = "transition-in-120-days"
          enabled   = true

          transition = [
            {
              days          = 120
              storage_class = "STANDARD_IA"
            }
          ]
        }
      ]
    },
  }
}

module "s3" {
  source   = "github.com/wmaramos/terraform-aws-s3-module?ref=v0.1.0"
  for_each = local.buckets

  bucket_name = each.key
  acl         = "private"

  lifecycle_rule = each.value.lifecycle_rule
}

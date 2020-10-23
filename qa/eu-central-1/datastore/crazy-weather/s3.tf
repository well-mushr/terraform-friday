module "crazy_berlin_hourly" {
  source = "github.com/wmaramos/terraform-aws-s3-module?ref=v0.1.0"

  bucket_name = "asdf-crazy-berlin-weather-hourly"
  acl         = "private"

  lifecycle_rule = [
    {
      rule_name = "expiration-in-7-days"
      enabled   = true

      expiration = {
        days = 7
      }
    }
  ]
}

module "crazy_berlin_daily" {
  source = "github.com/wmaramos/terraform-aws-s3-module?ref=v0.1.0"

  bucket_name = "asdf-crazy-berlin-weather-daily"
  acl         = "private"

  lifecycle_rule = [
    {
      rule_name = "expiration-in-30-days"
      enabled   = true

      expiration = {
        days = 30
      }
    }
  ]
}

module "crazy_berlin_weekly" {
  source = "github.com/wmaramos/terraform-aws-s3-module?ref=v0.1.0"

  bucket_name = "asdf-crazy-berlin-weather-weekly"
  acl         = "private"

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
}
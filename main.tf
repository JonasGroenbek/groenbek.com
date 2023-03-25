terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60.0"
    }
  }
}

# Main region where the resources should be created in
# Should be close to the location of your viewers
provider "aws" {
  region = "eu-west-1"
}

# Provider used for creating the Lambda@Edge function which must be deployed
# to us-east-1 region (Should not be changed)
provider "aws" {
  alias  = "global_region"
  region = "us-east-1"
}

###########
# Variables
###########

variable "custom_domain" {
  description = "test-groenbek.com"
  type        = string
  default     = "test-groenbek.com"
}

# Assuming that the ZONE of your domain is already available in your AWS account (Route 53)
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/AboutHZWorkingWith.html
variable "custom_domain_zone_name" {
  description = "The Route53 zone name of the custom domain"
  type        = string
  default     = "test-groenbek.com"
}

########
# Locals
########

locals {
  # A wildcard domain(ex: *.example.com) has to be added when using atomic deployments:
  aliases = [var.custom_domain, "*.${var.custom_domain}"]
}

#######################
# Route53 Domain record
#######################

# Get the hosted zone for the custom domain
data "aws_route53_zone" "custom_domain_zone" {
  name = var.custom_domain_zone_name
}

# Create a new record in Route 53 for the domain
resource "aws_route53_record" "cloudfront_alias_domain" {
  for_each = toset(local.aliases)

  zone_id = data.aws_route53_zone.custom_domain_zone.zone_id
  name    = each.key
  type    = "A"

  alias {
    name                   = module.tf_next.cloudfront_domain_name
    zone_id                = module.tf_next.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

// SSL Cert
module "cloudfront_cert" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.3.2"

  domain_name               = var.custom_domain
  zone_id                   = data.aws_route53_zone.custom_domain_zone.zone_id
  subject_alternative_names = slice(local.aliases, 1, length(local.aliases))

  wait_for_validation = true

  tags = {
    Name = "CloudFront ${var.custom_domain}"
  }

  # CloudFront works only with certs stored in us-east-1
  providers = {
    aws = aws.global_region
  }
}

// does all the heavy lifting regarding 
module "tf_next" {
  source  = "milliHQ/next-js/aws"
  version = "1.0.0-canary.5"

  cloudfront_aliases             = local.aliases
  cloudfront_acm_certificate_arn = module.cloudfront_cert.acm_certificate_arn

  deployment_name = "test-groenbek"
  providers = {
    aws.global_region = aws.global_region
  }
}

// this is used for deploying the nextjs application
output "api_endpoint" {
  value = module.tf_next.api_endpoint
}

// this is used for deploying the nextjs application
output "api_endpoint_access_policy_arn" {
  value = module.tf_next.api_endpoint_access_policy_arn
}

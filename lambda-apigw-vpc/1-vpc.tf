data "aws_region" "current" {}

data "aws_ec2_managed_prefix_list" "prefix" {
  name = "com.amazonaws.${data.aws_region.current.name}.s3"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version                     = "~> 5.1.1"
  name                        = "vpc-${random_string.suffix.result}"
  cidr                        = var.cidr
  azs                         = [for i in toset(var.azs) : "${data.aws_region.current.name}${i}"]
  intra_subnets               = [for i in toset(var.azs) : cidrsubnet(var.cidr, 8, index(var.azs, i))]
  intra_dedicated_network_acl = true
  intra_inbound_acl_rules = concat(
    # NACL rule for local traffic
    [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_block  = "10.0.0.0/16"
      },
    ],
    # NACL rules for the response traffic from addresses in the AWS S3 prefix list
    [for k, v in zipmap(
      range(length(data.aws_ec2_managed_prefix_list.prefix.entries[*].cidr)),
      data.aws_ec2_managed_prefix_list.prefix.entries[*].cidr
      ) :
      {
        rule_number = 200 + k
        rule_action = "allow"
        from_port   = 1024
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = v
      }
    ]
  )
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.1.1"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = module.vpc.intra_route_table_ids
    }
  }
}

module "security_group_lambda" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "lambda-sg-${random_string.suffix.result}"
  description = "Security Group for Lambda Egress"

  vpc_id = module.vpc.vpc_id

  egress_cidr_blocks      = []
  egress_ipv6_cidr_blocks = []

  # Prefix list ids to use in all egress rules in this module
  egress_prefix_list_ids = [module.vpc_endpoints.endpoints["s3"]["prefix_list_id"]]

  egress_rules = ["https-443-tcp"]
}
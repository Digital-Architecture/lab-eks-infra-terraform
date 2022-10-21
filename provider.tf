# NTTDATA - DIGITAL ARCHITECTURE
# Create: Marcos Cianci - mlopesci@emeal.nttdata.com


provider "aws" {
    region                      = local.aws_settings.region

    access_key                  = local.aws_settings.access_key
    secret_key                  = local.aws_settings.secret_key
    skip_credentials_validation = local.aws_settings.skip_credentials_validation
    skip_requesting_account_id  = local.aws_settings.skip_requesting_account_id
    skip_metadata_api_check     = local.aws_settings.skip_metadata_api_check
    s3_force_path_style         = local.aws_settings.s3_force_path_style

    dynamic "endpoints" {
        for_each = local.aws_settings.override_endpoint[*]
        content {
                apigateway     = endpoints.value
                apigatewayv2   = endpoints.value
                cloudformation = endpoints.value
                cloudwatch     = endpoints.value
                dynamodb       = endpoints.value
                ec2            = endpoints.value
                es             = endpoints.value
                elasticache    = endpoints.value
                firehose       = endpoints.value
                iam            = endpoints.value
                kinesis        = endpoints.value
                kms            = endpoints.value
                lambda         = endpoints.value
                rds            = endpoints.value
                redshift       = endpoints.value
                route53        = endpoints.value
                s3             = "http://s3.localhost.localstack.cloud:4566"
                secretsmanager = endpoints.value
                ses            = endpoints.value
                sns            = endpoints.value
                sqs            = endpoints.value
                ssm            = endpoints.value
                stepfunctions  = endpoints.value
                sts            = endpoints.value
        }
    }
}
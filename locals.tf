# NTTDATA - DIGITAL ARCHITECTURE
# Create: Marcos Cianci - mlopesci@emeal.nttdata.com

locals {

    use_localstack = (terraform.workspace == "local")
    region = var.region

    aws_settings = (

        local.use_localstack ? 
        {
            region                      = local.region
            access_key                  = "fake"
            secret_key                  = "fake"

            skip_credentials_validation = true
            skip_metadata_api_check     = true
            skip_requesting_account_id  = true
            s3_force_path_style         = true

            override_endpoint = "http://localhost:4566" 
        } :
        {
            region                      = local.region
            access_key                  = null 
            secret_key                  = null

            skip_credentials_validation = null
            skip_metadata_api_check     = null
            skip_requesting_account_id  = null
            s3_force_path_style         = null

            override_endpoint = null
        }
    )
}
terraform {
  backend "s3" {
    bucket       = "terraform-state-1771679503" # Replace with your S3 bucket name
    key          = "env/terraform.tfstate"
    region       = "us-east-1" # Replace with your region
    use_lockfile = true        # S3 Native Locking (No DynamoDB needed)
    encrypt      = true
  }
}

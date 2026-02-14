terraform {
  backend "s3" {
    bucket       = "malempati-cdops-lab-lambda-image-processing-state"
    key          = "dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
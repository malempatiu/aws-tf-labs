terraform {
  backend "s3" {
    bucket       = "malempati-cdops-lab-image-processor-state"
    key          = "dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
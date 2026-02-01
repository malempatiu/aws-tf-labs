/**
* TF stores Actual state of infra in S3 as a remote backend
* and it uses this to updated desired state by comparing to actual state.
* This way we ensure we that sensitive information will not be leaked to outside world.
*/
terraform {
  backend "s3" {
    bucket       = "malempati-cdops-lab-static-host-state-bucket"
    key          = "dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
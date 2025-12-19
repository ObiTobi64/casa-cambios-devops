terraform {
  backend "s3" {
    bucket         = "navi-upb-devops2025-terraform"
    key            = "proyecto2/casa-cambios-devops/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "navi-upb-devops2025-tfstate-locking"
    encrypt        = true
  }
}

terraform {
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket = "forstate2024"
    region = "ru-central1"
    key = "forstate2024/terraform.tfstate"
    skip_region_validation = true
    skip_credentials_validation = true
  }
}

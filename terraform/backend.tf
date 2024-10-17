terraform {
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket = "sbucket2024"
    region = "ru-central1"
    key = "sbucket2024/terraform.tfstate"
    skip_region_validation = true
    skip_credentials_validation = true
  }
}

terraform {
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket = "forstate2024"
    region = "ru-central1"
    key = "forstate2024/terraform.tfstate"
    access_key = "YCAJEk0WEkgcqfnS9NbLx7QZI"
    secret_key = "YCNY1ziiTS0WAkovEfvpNWH5-iohxe5jIz4_sVp9"
    skip_region_validation = true
    skip_credentials_validation = true
  }
}
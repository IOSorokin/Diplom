###cloud vars
variable "token" {
  type        = string
  default = "y0_AgAAAAA6B84_AATuwQAAAADzVHO07trw1FuYR3qClb2QXRHMfGSGT5s"
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  default = "b1g4ddikk6b9vpaieqqn"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default = "b1gtu3j8kgn0eg8c84kv"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "bucket_name" {
  type        = string
  default     = "ft-state"
  description = "VPC network&subnet name"
}

variable "account_name" {
  type        = string
  default     = "service"
  description = "VPC network&subnet name"
}
# Provider and backend
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  ## https://cloud.yandex.ru/docs/storage/operations/buckets/create
  # Задать переменными среды:
  #  export TFSTATE_YANDEX_ACESS_KEY=<key_value>
  #  export TFSTATE_YANDEX_SECRET_KEY=<key_value>
  #  export TFSTATE_YANDEX_BUCKET_NAME=<bucket_name>
  #  export TFSTATE_YANDEX_ZONE=<zone_name>
  # Запускать с ключём:
  #  terraform init \
  #    -backend-config="bucket=${TFSTATE_YANDEX_BUCKET_NAME}" \
  #    -backend-config="access_key=${TFSTATE_YANDEX_ACESS_KEY}" \
  #    -backend-config="secret_key=${TFSTATE_YANDEX_SECRET_KEY}" \
  #    -backend-config="region=${TFSTATE_YANDEX_ZONE}"

  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    key      = "terraform/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = var.yandex_cloud_id
  folder_id                = var.yandex_folder_id
  zone                     = var.yandex_zone
}

#resource "yandex_storage_bucket" "neto73_bucket" {
#  access_key = "${TFSTATE_YANDEX_ACESS_KEY}"
#  secret_key = "${TFSTATE_YANDEX_SECRET_KEY}"
#  bucket     = "${TFSTATE_YANDEX_BUCKET_NAME}"
#}
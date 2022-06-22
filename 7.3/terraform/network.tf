# Network
resource "yandex_vpc_network" "ubu-net" {
  name = "net-${terraform.workspace}"
}

resource "yandex_vpc_subnet" "ubu-subnet" {
  name           = "subnet-${terraform.workspace}"
  zone           = var.yandex_zone
  network_id     = yandex_vpc_network.ubu-net.id
  v4_cidr_blocks = ["${local.workspace["subnet_addr"]}.0/24"]
}

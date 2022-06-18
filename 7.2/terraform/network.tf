# Network
resource "yandex_vpc_network" "ubu-net" {
  name = "net"
}

resource "yandex_vpc_subnet" "ubu-subnet" {
  name           = "subnet"
  zone           = var.yandex_zone
  network_id     = yandex_vpc_network.ubu-net.id
  v4_cidr_blocks = ["${var.subnet_addr}.0/24"]
}

# https://cloud.yandex.ru/docs/dns/quickstart
# Public DNS zone
resource "yandex_dns_zone" "pub-zone" {
  name   = "public-zone"
  zone   = "${var.domain}."
  public = true
}

# Main A-rec for nginx
resource "yandex_dns_recordset" "rs1" {
  zone_id    = yandex_dns_zone.pub-zone.id
  name       = "${var.domain}."
  type       = "A"
  ttl        = 600
  data       = [yandex_compute_instance.proxy.network_interface[0].nat_ip_address]
  depends_on = [yandex_compute_instance.proxy]
}

# Some CNAMEs for third-lvl
resource "yandex_dns_recordset" "rs2" {
  zone_id    = yandex_dns_zone.pub-zone.id
  name       = "www"
  type       = "A"
  ttl        = 600
  data       = [yandex_compute_instance.proxy.network_interface[0].nat_ip_address]
  depends_on = [yandex_compute_instance.proxy]
}

resource "yandex_dns_recordset" "rs3" {
  zone_id    = yandex_dns_zone.pub-zone.id
  name       = "gitlab"
  type       = "A"
  ttl        = 600
  data       = [yandex_compute_instance.proxy.network_interface[0].nat_ip_address]
  depends_on = [yandex_compute_instance.proxy]
}

resource "yandex_dns_recordset" "rs4" {
  zone_id    = yandex_dns_zone.pub-zone.id
  name       = "grafana"
  type       = "A"
  ttl        = 600
  data       = [yandex_compute_instance.proxy.network_interface[0].nat_ip_address]
  depends_on = [yandex_compute_instance.proxy]
}

resource "yandex_dns_recordset" "rs5" {
  zone_id    = yandex_dns_zone.pub-zone.id
  name       = "prometheus"
  type       = "A"
  ttl        = 600
  data       = [yandex_compute_instance.proxy.network_interface[0].nat_ip_address]
  depends_on = [yandex_compute_instance.proxy]
}

resource "yandex_dns_recordset" "rs6" {
  zone_id    = yandex_dns_zone.pub-zone.id
  name       = "alertmanager"
  type       = "A"
  ttl        = 600
  data       = [yandex_compute_instance.proxy.network_interface[0].nat_ip_address]
  depends_on = [yandex_compute_instance.proxy]
}
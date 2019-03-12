resource "google_compute_network" "appsbroker_network" {
  name                        = "appsbrokernetwork"
  auto_create_subnetworks     = false
}

resource "google_compute_subnetwork" "appsbroker_subnet" {
  ip_cidr_range               = "${var.gcp_ip_cidr_range}"
  name                        = "${var.subnet_names["subnet1"]}"
  network                     = "${google_compute_network.appsbroker_network.name}"
}



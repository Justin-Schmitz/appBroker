resource "google_compute_firewall" "appsbroker-firewall-ssh" {
  ## firewall rules enabling the load balancer health checks
  name                = "${var.network_name}-allow-ssh"
  network             = "${google_compute_network.appsbroker_network.name}"
  description         = "Allow :22 from small range"

  allow {
    protocol          = "tcp"
    ports             = ["22"]
  }
  target_tags         = ["appsbrokerfirewallssh"]
  source_ranges       = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "appsbroker-firewall-http" {
  name                = "${var.network_name}-allow-http"
  network             = "${google_compute_network.appsbroker_network.name}"

  allow {
    protocol          = "tcp"
    ports             = ["80"]
  }
  target_tags         = ["appsbrokerfirewallhttp"]
}
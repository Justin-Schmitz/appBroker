resource "google_compute_region_instance_group_manager" "appsbroker" {
  name                        = "appsbroker-${var.region}"

  base_instance_name          = "appsbroker-${var.region}"
  region                      = "${var.region}"
  instance_template           = "${google_compute_instance_template.appsbroker.self_link}"

  named_port {
    name                      = "appsbroker"
    port                      = 80
  }
}

resource "google_compute_instance_template" "appsbroker" {
  description                 = "the appsbroker backend application."

  tags = ["appsbroker"]
  instance_description        = "appsbroker backend"
  machine_type                = "g1-small"
  can_ip_forward              = false
  metadata_startup_script     = "sudo apt-get update; sudo apt-get install -y nginx; sudo systemctl start nginx"
  metadata {
    ssh-keys                  = "${var.appsb_ssh_user}:${file(var.appsb_ssh_pub_key_file)}"
  }
  provisioner "file" {
    source                    = "${file("./index.html")}"
    destination               = "/usr/local/nginx/html/index.html"
  }


  scheduling {
    automatic_restart         = false
    on_host_maintenance       = "TERMINATE"
    preemptible               = true
  }

  disk {
    source_image              = "${data.google_compute_image.cos_image.self_link}"
    auto_delete               = true
    boot                      = true
  }

  network_interface {
    network                   = "default"

    access_config {
      nat_ip                  = ""
    }
  }

#  metadata {
#    "startup-script"         = "docker run -d -p 80:80 nginx:latest"
#  }

  lifecycle {
    create_before_destroy     = true
  }
}

resource "google_compute_region_autoscaler" "appsbroker" {
  name                        = "appsbroker-${var.region}"
  target                      = "${google_compute_region_instance_group_manager.appsbroker.self_link}"

  autoscaling_policy          = {
    max_replicas              = 5
    min_replicas              = 1
    cooldown_period           = 60

    cpu_utilization {
      target                  = 0.5
    }
  }

  region                      = "${var.region}"
}

resource "google_compute_http_health_check" "appsbroker" {
  name                        = "appsbroker-${var.region}"
  request_path                = "/"

  timeout_sec                 = 5
  check_interval_sec          = 5
  port                        = 80
  connection {}

  lifecycle {
    create_before_destroy     = true
  }
}

data "google_compute_image" "cos_image" {
  family                      = "cos-stable"
  project                     = "cos-cloud"
}

output "instance_group_manager" {
  value                       = "${google_compute_region_instance_group_manager.appsbroker.instance_group}"
}

output "health_check" {
  value                       = "${google_compute_http_health_check.appsbroker.self_link}"
}
provider "google" {
  credentials = ""
  project     = "${var.project}"
  region      = "${var.region}"
}

resource "google_container_cluster" "primary" {
  name     = "${var.cluster.name}"
  network = "${var.cluster.network}"
  location = "${var.region}" 

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = "${var.cluster.remove_default_node_pool}"
  initial_node_count = "${var.cluster.initial_node_count}"

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = "${var.client_certificate}"
    }
  }
}

resource "google_container_node_pool" "node_pool" {
  name       = "${var.node_pool.name}"
  location   = "${var.region}"
  cluster    = "${google_container_cluster.primary.name}"
  initial_node_count = "${var.node_pool.initial_node_count}"

  management {
    auto_repair = "${var.mgmt.auto_repair}"
    auto_upgrade = "${var.mgmt.auto_upgrade}"
  }

  autoscaling {
    min_node_count = "${var.node_pool.min_node_count}"
    max_node_count = "${var.node_pool.max_node_count}"
  }

  node_config {
    preemptible  = "${var.node_config.preemptible}"
    machine_type = "${var.node_config.machine_type}"

    metadata = {
      disable-legacy-endpoints = "${var.disable-legacy-endpoints}"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}

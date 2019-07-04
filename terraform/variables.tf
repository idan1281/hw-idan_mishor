variable "project" { default = "devops-test-245321" }
variable "region" { default = "europe-west1"}
variable "creds" { default = "" }
variable "client_certificate" { default = "false" }
variable "disable-legacy-endpoints" { default = "true"}

variable "cluster" {
    type = "map"
    default = {
       name     = "playground"
       network = "default"
       remove_default_node_pool = "true"
       initial_node_count = 1
    }
}

variable "node_pool" {
    type = "map"
    default = {
       name     = "my-node-pool"
       initial_node_count = 2
       min_node_count = 2
       max_node_count = 10
    }
}

variable "mgmt" {
    type = "map"
    default = {
       auto_repair = "true"
       auto_upgrade = "false"
    }
}

variable "node_config" {
    type = "map"
    default = {
       preemptible  = false
       machine_type = "n1-standard-1"
    }
}

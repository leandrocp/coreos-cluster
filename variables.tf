variable "gce_master_instance_count" {
    description = "Number of master instances in GCE"
    default = 3
}

variable "gce_slave_instance_count" {
    description = "Number of slave instances in GCE"
    default = 1
}

variable "gce_account_file" {
    description = "Path to your GCE account credentials file"
    default = "gce_account_sisprev.json"
}

variable "gce_project_name" {
    description = "Name of your existing GCE project"
    default = "sisprev-966"
}

variable "gce_region" {
    description = "Region to run GCE instances in"
    default = "us-central1"
}

variable "gce_zone" {
    description = "Zone to run GCE instances in"
    default = "us-central1-b"
}

variable "gce_key_path" {
    description = "Path to private SSH key for the GCE instances"
    default = "~/.ssh/google_compute_engine"
}

variable "gce_coreos_disk_image" {
    description = "Name of CoreOS Root disk image for the GCE instances to use"
    default = "coreos-beta-681-0-0-v20150527"
}

variable "gce_machine_type" {
    description = "Type of instance ot use in GCE"
    default = "n1-standard-1"
}

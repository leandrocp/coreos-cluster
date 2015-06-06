provider "google" {
  account_file = "${var.gce_account_file}"
  project = "${var.gce_project_name}"
  region = "${var.gce_region}"
}

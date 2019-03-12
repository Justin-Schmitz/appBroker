terraform {
  backend "gcs" {
    bucket          = "appsbroker_backend"
    prefix          = "terraform/state"
    credentials     = "../account.json"
  }
}
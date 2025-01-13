module "cloud_router" {
  source = "../"

  project            = "my-project"
  region             = "us-central1"
  network            = "default"
  router_name        = "simple-router"
  router_description = "Simple Cloud Router example"
}

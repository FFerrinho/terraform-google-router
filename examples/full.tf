module "cloud_router" {
  source = "../../"

  project     = "my-project"
  region      = "europe-west1"
  router_name = "my-router"
  network     = "projects/my-project/global/networks/my-network"

  # BGP configuration
  bgp = [{
    asn               = 65000
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
  }]

  # Router interfaces
  router_interface = {
    interface1 = {
      name       = "if-1"
      ip_range   = "169.254.0.1/30"
      vpn_tunnel = "vpn-tunnel-1"
    }
  }

  # BGP peers
  router_peering = {
    peer1 = {
      name                = "bgp-peer-1"
      interface           = "if-1"
      peer_asn           = 65001
      ip_address         = "169.254.0.1"
      peer_ip_address    = "169.254.0.2"
      advertise_mode     = "CUSTOM"
      advertised_groups  = ["ALL_SUBNETS"]
      enable             = true
      enable_ipv4        = true
    }
  }

  # Routes
  routes = {
    route-1 = {
      name          = "route-to-onprem"
      dest_range    = "192.168.0.0/24"
      priority      = 1000
      next_hop_gateway = "default-internet-gateway"
    }
    route-2 = {
      name          = "route-to-instance"
      dest_range    = "10.0.0.0/24"
      priority      = 900
      next_hop_instance = "projects/my-project/zones/europe-west1-b/instances/instance-1"
      next_hop_instance_zone = "europe-west1-b"
    }
    route-3 = {
      name          = "route-to-ip"
      dest_range    = "172.16.0.0/24"
      priority      = 800
      next_hop_ip   = "10.0.0.100"
      tags          = ["app-tier"]
    }
  }
}

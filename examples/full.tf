module "cloud_router" {
  source = "../"

  project            = "my-project"
  region             = "us-central1"
  network            = "custom-network"
  router_name        = "complex-router"
  router_description = "Complex Cloud Router example with all features"

  bgp = [{
    asn                = 64512
    advertise_mode     = "CUSTOM"
    advertised_groups  = ["ALL_SUBNETS"]
    keepalive_interval = 20
    advertised_ip_ranges = {
      range       = "192.168.1.0/24"
      description = "Internal network range"
    }
  }]

  router_interface = {
    interface1 = {
      name                = "if-1"
      ip_range            = "169.254.1.1/30"
      vpn_tunnel          = "vpn-tunnel-1"
      redundant_interface = "if-2"
    }
    interface2 = {
      name       = "if-2"
      ip_range   = "169.254.2.1/30"
      vpn_tunnel = "vpn-tunnel-2"
    }
  }

  router_peering = {
    peer1 = {
      name                          = "bgp-peer-1"
      interface                     = "if-1"
      peer_asn                      = 65534
      ip_address                    = "169.254.1.1"
      peer_ip_address               = "169.254.1.2"
      advertised_route_priority     = 100
      advertise_mode                = "CUSTOM"
      advertised_groups             = ["ALL_SUBNETS"]
      custom_learned_route_priority = 200
      enable                        = true
      enable_ipv4                   = true
      bfd = [{
        session_initialization_mode = "ACTIVE"
        min_transmit_interval       = 1000
        min_receive_interval        = 1000
        multiplier                  = 5
      }]
      advertised_ip_ranges = [{
        range       = "10.0.0.0/8"
        description = "Primary DC network"
      }]
    }
  }
}

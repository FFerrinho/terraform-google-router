# Router outputs
output "router" {
  description = "Cloud Router resource"
  value = var.router_name != "" ? {
    id          = google_compute_router.main[0].id
    self_link   = google_compute_router.main[0].self_link
    name        = google_compute_router.main[0].name
    created_at  = google_compute_router.main[0].creation_timestamp
    network     = google_compute_router.main[0].network
    region      = google_compute_router.main[0].region
    bgp_details = google_compute_router.main[0].bgp
  } : null
}

# Interface outputs 
output "interfaces" {
  description = "Map of router interface resources"
  value = {
    for k, v in google_compute_router_interface.main : k => {
      id                  = v.id
      name                = v.name
      region             = v.region
      ip_range           = v.ip_range
      private_ip_address = v.private_ip_address
      subnetwork         = v.subnetwork
    }
  }
}

# Peer outputs
output "peers" {
  description = "Map of BGP peer resources"
  value = {
    for k, v in google_compute_router_peer.main : k => {
      id                      = v.id
      name                    = v.name
      interface              = v.interface
      peer_asn               = v.peer_asn
      peer_ip_address        = v.peer_ip_address
      advertised_route_priority = v.advertised_route_priority
      advertise_mode         = v.advertise_mode
      advertised_groups      = v.advertised_groups
      advertised_ip_ranges   = v.advertised_ip_ranges
      bfd_status            = v.bfd
    }
  }
}

# Routes outputs
# Replace routes output with:
output "routes" {
  description = "Map of route resources"
  value = try({
    for k, v in var.routes != null ? var.routes : {} : k => {
      name                   = v.name
      dest_range            = v.dest_range
      priority              = v.priority
      next_hop_gateway      = v.next_hop_gateway
      next_hop_ip           = v.next_hop_ip
      next_hop_instance     = v.next_hop_instance
      next_hop_instance_zone = v.next_hop_instance_zone
    }
  }, {})
}

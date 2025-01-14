output "router" {
  description = "The created Cloud Router resource"
  value = var.router_name != "" ? {
    id         = google_compute_router.main[0].id
    self_link  = google_compute_router.main[0].self_link
    name       = google_compute_router.main[0].name
    created_at = google_compute_router.main[0].creation_timestamp
    bgp        = google_compute_router.main[0].bgp
  } : null
}

output "router_interfaces" {
  description = "Map of created router interfaces"
  value = {
    for k, v in google_compute_router_interface.main : k => {
      id        = v.id
      name      = v.name
      ip_range  = v.ip_range
      self_link = v.self_link
    }
  }
}

output "router_peers" {
  description = "Map of created BGP peers"
  value = {
    for k, v in google_compute_router_peer.main : k => {
      id         = v.id
      name       = v.name
      peer_asn   = v.peer_asn
      self_link  = v.self_link
      state_info = v.state_info
    }
  }
}

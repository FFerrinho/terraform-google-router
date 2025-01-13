resource "google_compute_router" "main" {
  count       = var.router_name
  name        = var.router_name
  network     = var.network
  description = var.router_description
  region      = var.region
  project     = var.project

  dynamic "bgp" {
    for_each = var.bgp
    content {
      asn                = bgp.value.asn != null ? bgp.value.asn : ""
      advertise_mode     = bgp.value.advertise_mode != null ? bgp.value.advertise_mode : ""
      advertised_groups  = bgp.value.advertised_groups != null ? bgp.value.advertised_groups : ""
      keepalive_interval = bgp.value.keepalive_interval != null ? bgp.value.keepalive_interval : ""
      identifier_range   = bgp.value.identifier_range != null ? bgp.value.identifier_range : ""

      dynamic "advertised_ip_ranges" {
        for_each = bgp.value.advertised_ip_ranges
        content {
          range       = advertised_ip_ranges.value.range != null ? advertised_ip_ranges.value.range : ""
          description = advertised_ip_ranges.value.description != null ? advertised_ip_ranges.value.description : ""
        }
      }
    }
  }
}

resource "google_compute_router_interface" "main" {
    for_each            = var.router_interface
    name                = each.value.name
    router              = var.router_name != null ? google_compute_router.main[0].self_link : var.remote_router_self_link
    ip_range            = each.value.ip_range
    ip_version          = each.value.ip_version
    vpn_tunnel          = each.value.vpn_tunnel
    redundant_interface = each.value.redundant_interface
    project             = var.project
    subnetwork          = each.value.subnetwork
    private_ip_address  = each.value.private_ip_address
    region              = var.region
}

# TODO Switch to for_each since multiple peers may be required
resource "google_compute_router_peer" "main" {
  count                         = var.router_peer_name
  name                          = var.router_peer_name
  interface                     = var.router_peer_interface
  peer_asn                      = var.peer_asn
  router                        = var.router_name != null ? google_compute_router.main[0].self_link : var.remote_router_self_link
  ip_address                    = var.own_peer_ip_address
  peer_ip_address               = var.peer_ip_address
  advertised_route_priority     = var.advertised_route_priority
  advertise_mode                = var.advertise_mode
  advertised_groups             = var.advertised_groups
  custom_learned_route_priority = var.custom_learned_route_priority
  enable                        = var.router_peer_enabled
  enable_ipv4                   = var.enable_ipv4
  enable_ipv6                   = var.enable_ipv6
  region                        = var.region
  project                       = var.project

  dynamic "advertised_ip_ranges" {
    for_each = var.advertised_ip_ranges
    content {
      range       = advertised_ip_ranges.value.range
      description = advertised_ip_ranges.value.description
    }
  }

  dynamic "custom_learned_ip_ranges" {
    for_each = var.custom_learned_ip_ranges
    content {
      range = custom_learned_ip_ranges.value.range
    }
  }

  dynamic "bfd" {
    for_each = var.bfd
    content {
      session_initialization_mode = bfd.value.session_initialization_mode
      min_transmit_interval       = bfd.value.min_transmit_interval
      min_receive_interval        = bfd.value.min_receive_interval
      multiplier                  = bfd.value.multiplier
    }
  }

  lifecycle {
    precondition {
      condition     = var.advertise_mode != "CUSTOM" ? length(var.advertised_groups) == 0 : true
      error_message = "advertised_groups can only be used when advertise_mode is set to CUSTOM"
    }
    precondition {
      condition     = var.advertise_mode != "CUSTOM" ? length(var.advertised_ip_ranges) == 0 : true
      error_message = "advertised_ip_ranges can only be used when advertise_mode is set to CUSTOM"
    }
  }
}

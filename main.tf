resource "random_integer" "main" {
  min = 64512
  max = 65534
}

resource "google_compute_router" "main" {
  count       = var.router_name != "" ? 1 : 0
  name        = var.router_name
  network     = var.network
  description = var.router_description
  region      = var.region
  project     = var.project

  dynamic "bgp" {
    for_each = var.bgp != null ? var.bgp : []
    content {
      asn = bgp.value.asn != null ? bgp.value.asn : random_integer.main.result

      advertise_mode     = bgp.value.advertise_mode != null ? bgp.value.advertise_mode : "DEFAULT"
      advertised_groups  = bgp.value.advertised_groups != null ? bgp.value.advertised_groups : []
      keepalive_interval = bgp.value.keepalive_interval != null ? bgp.value.keepalive_interval : null
      identifier_range   = bgp.value.identifier_range != null ? bgp.value.identifier_range : null

      dynamic "advertised_ip_ranges" {
        for_each = bgp.value.advertised_ip_ranges != null ? [bgp.value.advertised_ip_ranges] : []
        content {
          range       = advertised_ip_ranges.value.range != null ? advertised_ip_ranges.value.range : null
          description = advertised_ip_ranges.value.description != null ? advertised_ip_ranges.value.description : null
        }
      }
    }
  }
}

resource "google_compute_router_interface" "main" {
  for_each            = var.router_interface != null ? var.router_interface : {}
  name                = each.value.name
  router              = var.remote_router_name == null ? google_compute_router.main[0].name : var.remote_router_name
  ip_range            = each.value.ip_range
  ip_version          = each.value.ip_version
  vpn_tunnel          = each.value.vpn_tunnel
  redundant_interface = each.value.redundant_interface
  project             = var.project
  subnetwork          = each.value.subnetwork
  private_ip_address  = each.value.private_ip_address
  region              = var.region

  lifecycle {
    precondition {
      condition     = !(each.value.redundant_interface != null && each.value.vpn_tunnel != null)
      error_message = "Cannot specify both redundant_interface and vpn_tunnel for interface ${each.value.name}"
    }
  }
}

resource "google_compute_router_peer" "main" {
  for_each                      = var.router_peering != null ? var.router_peering : {}
  name                          = each.value.name
  interface                     = each.value.interface
  peer_asn                      = each.value.peer_asn
  router                        = var.remote_router_name == null ? google_compute_router.main[0].name : var.remote_router_name
  ip_address                    = each.value.ip_address
  peer_ip_address               = each.value.peer_ip_address
  advertised_route_priority     = each.value.advertised_route_priority
  advertise_mode                = each.value.advertise_mode
  advertised_groups             = each.value.advertised_groups
  custom_learned_route_priority = each.value.custom_learned_route_priority
  enable                        = each.value.enable
  enable_ipv4                   = each.value.enable_ipv4
  enable_ipv6                   = each.value.enable_ipv6
  region                        = var.region != null ? var.region : each.value.region
  project                       = var.project != null ? var.project : each.value.project

  dynamic "advertised_ip_ranges" {
    for_each = each.value.advertised_ip_ranges != null ? each.value.advertised_ip_ranges : []
    content {
      range       = advertised_ip_ranges.value.range
      description = advertised_ip_ranges.value.description
    }
  }

  dynamic "custom_learned_ip_ranges" {
    for_each = each.value.custom_learned_ip_ranges != null ? each.value.custom_learned_ip_ranges : []
    content {
      range = custom_learned_ip_ranges.value.range
    }
  }

  dynamic "bfd" {
    for_each = each.value.bfd != null ? each.value.bfd : []
    content {
      session_initialization_mode = bfd.value.session_initialization_mode
      min_transmit_interval       = bfd.value.min_transmit_interval
      min_receive_interval        = bfd.value.min_receive_interval
      multiplier                  = bfd.value.multiplier
    }
  }

  lifecycle {
    precondition {
      condition     = each.value.advertise_mode != "CUSTOM" ? length(coalesce(each.value.advertised_groups, [])) == 0 : true
      error_message = "advertised_groups can only be used when advertise_mode is set to CUSTOM"
    }
    precondition {
      condition     = each.value.advertise_mode != "CUSTOM" ? length(coalesce(each.value.advertised_ip_ranges, [])) == 0 : true
      error_message = "advertised_ip_ranges can only be used when advertise_mode is set to CUSTOM"
    }
  }
}

resource "google_compute_route" "main" {
  for_each               = var.routes != null ? var.routes : {}
  dest_range             = each.value.dest_range
  name                   = lower(each.key)
  network                = var.network
  description            = each.value.description
  priority               = each.value.priority
  tags                   = each.value.tags
  next_hop_gateway       = each.value.next_hop_gateway
  next_hop_instance      = each.value.next_hop_instance
  next_hop_instance_zone = each.value.next_hop_instance_zone
  next_hop_ip            = each.value.next_hop_ip
  next_hop_vpn_tunnel    = each.value.next_hop_vpn_tunnel
  next_hop_ilb           = each.value.next_hop_ilb
  project                = var.project

  lifecycle {
    precondition {
      condition = (
        try(each.value.next_hop_gateway, "") != "" ||
        try(each.value.next_hop_instance, "") != "" ||
        try(each.value.next_hop_ip, "") != "" ||
        try(each.value.next_hop_vpn_tunnel, "") != "" ||
        try(each.value.next_hop_ilb, "") != ""
      )
      error_message = "At least one next_hop argument must be specified for route ${each.key}"
    }
  }
}

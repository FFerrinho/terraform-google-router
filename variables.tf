###########################################
#            Common Variables             #
###########################################

variable "network" {
  description = "The network for the VPN Gateway."
  type        = string
}

variable "region" {
  description = "The region for the VPN Gateway."
  type        = string
}

variable "project" {
  description = "The project for the VPN Gateway."
  type        = string
}

###########################################
#            Router Variables             #
###########################################

variable "router_name" {
  description = "The name for the Cloud Router."
  type        = string
}

variable "router_description" {
  description = "A description for the Cloud Router."
  type        = string
  default     = null
}

variable "bgp" {
  description = "A list of BGP configurations for the Cloud Router."
  type = list(object({
    asn                = number
    advertise_mode     = optional(string)
    advertised_groups  = optional(list(string))
    keepalive_interval = optional(number)
    identifier_range   = optional(string)
    advertised_ip_ranges = optional(object({
      range       = string
      description = optional(string)
    }))
  }))
  default = null
}

variable "router_interface" {
  description = "A list of Router Interface configurations for the Cloud Router."
  type = map(object({
    name                = optional(string)
    ip_range            = optional(string)
    ip_version          = optional(string)
    vpn_tunnel          = optional(string)
    redundant_interface = optional(string)
    subnetwork          = optional(string)
    private_ip_address  = optional(string)
  }))
  default = null
}

variable "router_peering" {
  description = "A list of Router Peering configurations for the Cloud Router."
  type = map(object({
    name      = optional(string)
    interface = optional(string)
    peer_asn  = optional(number)

    ip_address                    = optional(string)
    peer_ip_address               = optional(string)
    advertised_route_priority     = optional(number)
    advertise_mode                = optional(string)
    advertised_groups             = optional(list(string))
    custom_learned_route_priority = optional(number)
    enable                        = optional(bool)
    enable_ipv4                   = optional(bool)
    enable_ipv6                   = optional(bool)
    region                        = optional(string)
    project                       = optional(string)
    advertised_ip_ranges = optional(list(object({
      range       = string
      description = optional(string)
    })))
    custom_learned_ip_ranges = optional(list(object({
      range = string
    })))
    bfd = optional(list(object({
      session_initialization_mode = optional(string)
      min_transmit_interval       = optional(number)
      min_receive_interval        = optional(number)
      multiplier                  = optional(number)
    })))
  }))
  default = null

  validation {
    condition = var.router_peering == null ? true : alltrue([
      for k, v in var.router_peering :
      v.advertise_mode == null || contains(["CUSTOM", "DEFAULT"], v.advertise_mode)
    ])
    error_message = "advertise_mode must be one of: CUSTOM, DEFAULT"
  }

  validation {
    condition = var.router_peering == null ? true : alltrue([
      for k, v in var.router_peering :
      v.bfd == null ? true : alltrue([
        for b in v.bfd :
        b.session_initialization_mode == null ? true : contains(["ACTIVE", "DISABLED", "PASSIVE"], b.session_initialization_mode)
      ])
    ])
    error_message = "session_initialization_mode must be one of: ACTIVE, DISABLED, PASSIVE"
  }

  validation {
    condition = var.router_peering == null ? true : alltrue([
      for k, v in var.router_peering :
      v.bfd == null ? true : alltrue([
        for b in v.bfd :
        b.min_transmit_interval == null ? true : (b.min_transmit_interval >= 1000 && b.min_transmit_interval <= 30000)
      ])
    ])
    error_message = "min_transmit_interval must be between 1000 and 30000"
  }

  validation {
    condition = var.router_peering == null ? true : alltrue([
      for k, v in var.router_peering :
      v.bfd == null ? true : alltrue([
        for b in v.bfd :
        b.min_receive_interval == null ? true : (b.min_receive_interval >= 1000 && b.min_receive_interval <= 30000)
      ])
    ])
    error_message = "min_receive_interval must be between 1000 and 30000"
  }

  validation {
    condition = var.router_peering == null ? true : alltrue([
      for k, v in var.router_peering :
      v.bfd == null ? true : alltrue([
        for b in v.bfd :
        b.multiplier == null ? true : (b.multiplier >= 5 && b.multiplier <= 16)
      ])
    ])
    error_message = "multiplier must be between 5 and 16"
  }
}

variable "remote_router_self_link" {
  description = "The self link for the remote Cloud Router."
  type        = string
  default     = null
}

variable "routes" {
  description = "A list of Route configurations for the Cloud Router."
  type = map(object({
    dest_range             = optional(string)
    name                   = optional(string)
    network                = optional(string)
    description            = optional(string)
    priority               = optional(number)
    tags                   = optional(list(string))
    next_hop_gateway       = optional(string)
    next_hop_instance      = optional(string)
    next_hop_ip            = optional(string)
    next_hop_instance_zone = optional(string)
  }))
  default = null
}

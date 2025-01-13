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

  validation {
    condition     = var.bgp == null || alltrue([for b in var.bgp : (b.asn >= 64512 && b.asn <= 65534) || (b.asn >= 4200000000 && b.asn <= 4294967294)])
    error_message = "ASN must be either a 16-bit private ASN (64512-65534) or a 32-bit private ASN (4200000000-4294967294) per RFC6996"
  }
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

variable "router_peer_name" {
  description = "The name for the Cloud Router Peer."
  type        = string
  default     = null
}

variable "router_peer_interface" {
  description = "The interface for the Cloud Router Peer."
  type        = string
  default     = null
}

variable "peer_asn" {
  description = "The peer ASN for the Cloud Router Peer."
  type        = number
  default     = null
}

variable "own_peer_ip_address" {
  description = "The peer IP address for the Cloud Router Peer."
  type        = string
  default     = null
}

variable "peer_ip_address" {
  description = "The peer IP address for the Cloud Router Peer."
  type        = string
  default     = null
}

variable "advertised_route_priority" {
  description = "The advertised route priority for the Cloud Router Peer."
  type        = number
  default     = null
}

variable "advertise_mode" {
  description = "The advertise mode for the Cloud Router Peer."
  type        = string
  default     = null

  validation {
    condition     = contains(["CUSTOM", "DEFAULT"], var.advertise_mode)
    error_message = "advertise_mode must be one of: CUSTOM, DEFAULT"
  }
}

variable "advertised_groups" {
  description = "The advertised groups for the Cloud Router Peer."
  type        = list(string)
  default     = null
}

variable "custom_learned_route_priority" {
  description = "The custom learned route priority for the Cloud Router Peer."
  type        = number
  default     = null

  validation {
    condition     = var.custom_learned_route_priority == null || (var.custom_learned_route_priority >= 0 && var.custom_learned_route_priority <= 65535)
    error_message = "custom_learned_route_priority must be between 0 and 65535"
  }
}

variable "router_peer_enabled" {
  description = "The enabled status for the Cloud Router Peer."
  type        = bool
  default     = null
}

variable "advertised_ip_ranges" {
  description = "The advertised IP ranges for the Cloud Router Peer."
  type = list(object({
    range       = string
    description = optional(string)
  }))
  default = null
}

variable "custom_learned_ip_ranges" {
  description = "The custom learned IP ranges for the Cloud Router Peer."
  type = list(object({
    range = string
  }))
  default = null
}

variable "enable_ipv4" {
  description = "The enabled status for IPv4 for the Cloud Router Peer."
  type        = bool
  default     = null
}

variable "enable_ipv6" {
  description = "The enabled status for IPv6 for the Cloud Router Peer."
  type        = bool
  default     = null
}

variable "bfd" {
  description = "The BFD configuration for the Cloud Router Peer."
  type = list(object({
    session_initialization_mode = optional(string)
    min_transmit_interval       = optional(number)
    min_receive_interval        = optional(number)
    multiplier                  = optional(number)
  }))
  default = null

  validation {
    condition     = var.bfd == null || alltrue([for b in var.bfd : contains(["ACTIVE", "DISABLED", "PASSIVE"], b.session_initialization_mode)])
    error_message = "session_initialization_mode must be one of: ACTIVE, DISABLED, PASSIVE"
  }

  validation {
    condition     = var.bfd == null || alltrue([for b in var.bfd : b.min_transmit_interval == null || (b.min_transmit_interval >= 1000 && b.min_transmit_interval <= 30000)])
    error_message = "min_transmit_interval must be between 1000 and 30000"
  }

  validation {
    condition     = var.bfd == null || alltrue([for b in var.bfd : b.min_receive_interval == null || (b.min_receive_interval >= 1000 && b.min_receive_interval <= 30000)])
    error_message = "min_receive_interval must be between 1000 and 30000"
  }

  validation {
    condition     = var.bfd == null || alltrue([for b in var.bfd : b.multiplier == null || (b.multiplier >= 5 && b.multiplier <= 16)])
    error_message = "multiplier must be between 5 and 16"
  }
}

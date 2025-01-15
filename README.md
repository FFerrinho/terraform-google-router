## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.15.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_route.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |
| [google_compute_router.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_interface.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_interface) | resource |
| [google_compute_router_peer.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_peer) | resource |
| [random_integer.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bgp"></a> [bgp](#input\_bgp) | A list of BGP configurations for the Cloud Router. | <pre>list(object({<br>    asn                = number<br>    advertise_mode     = optional(string)<br>    advertised_groups  = optional(list(string))<br>    keepalive_interval = optional(number)<br>    identifier_range   = optional(string)<br>    advertised_ip_ranges = optional(object({<br>      range       = string<br>      description = optional(string)<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_network"></a> [network](#input\_network) | The network for the VPN Gateway. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project for the VPN Gateway. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region for the VPN Gateway. | `string` | n/a | yes |
| <a name="input_remote_router_name"></a> [remote\_router\_name](#input\_remote\_router\_name) | The self link for the remote Cloud Router. | `string` | `null` | no |
| <a name="input_router_description"></a> [router\_description](#input\_router\_description) | A description for the Cloud Router. | `string` | `null` | no |
| <a name="input_router_interface"></a> [router\_interface](#input\_router\_interface) | A list of Router Interface configurations for the Cloud Router. | <pre>map(object({<br>    name                = optional(string)<br>    ip_range            = optional(string)<br>    ip_version          = optional(string)<br>    vpn_tunnel          = optional(string)<br>    redundant_interface = optional(string)<br>    subnetwork          = optional(string)<br>    private_ip_address  = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_router_name"></a> [router\_name](#input\_router\_name) | The name for the Cloud Router. | `string` | n/a | yes |
| <a name="input_router_peering"></a> [router\_peering](#input\_router\_peering) | A list of Router Peering configurations for the Cloud Router. | <pre>map(object({<br>    name      = optional(string)<br>    interface = optional(string)<br>    peer_asn  = optional(number)<br><br>    ip_address                    = optional(string)<br>    peer_ip_address               = optional(string)<br>    advertised_route_priority     = optional(number)<br>    advertise_mode                = optional(string)<br>    advertised_groups             = optional(list(string))<br>    custom_learned_route_priority = optional(number)<br>    enable                        = optional(bool)<br>    enable_ipv4                   = optional(bool)<br>    enable_ipv6                   = optional(bool)<br>    region                        = optional(string)<br>    project                       = optional(string)<br>    advertised_ip_ranges = optional(list(object({<br>      range       = string<br>      description = optional(string)<br>    })))<br>    custom_learned_ip_ranges = optional(list(object({<br>      range = string<br>    })))<br>    bfd = optional(list(object({<br>      session_initialization_mode = optional(string)<br>      min_transmit_interval       = optional(number)<br>      min_receive_interval        = optional(number)<br>      multiplier                  = optional(number)<br>    })))<br>  }))</pre> | `null` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | A list of Route configurations for the Cloud Router. | <pre>map(object({<br>    dest_range             = optional(string)<br>    network                = optional(string)<br>    description            = optional(string)<br>    priority               = optional(number)<br>    tags                   = optional(list(string))<br>    next_hop_gateway       = optional(string)<br>    next_hop_instance      = optional(string)<br>    next_hop_instance_zone = optional(string)<br>    next_hop_ip            = optional(string)<br>    next_hop_vpn_tunnel    = optional(string)<br>    next_hop_ilb           = optional(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_interfaces"></a> [interfaces](#output\_interfaces) | Map of router interface resources |
| <a name="output_peers"></a> [peers](#output\_peers) | Map of BGP peer resources |
| <a name="output_router"></a> [router](#output\_router) | Cloud Router resource |
| <a name="output_routes"></a> [routes](#output\_routes) | Map of route resources |

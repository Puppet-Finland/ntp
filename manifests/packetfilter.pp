#
# == Class ntp::packetfilter
#
# Configures packetfiltering rules for ntpd
#
class ntp::packetfilter
(
    $allow_address_ipv4,
    $allow_address_ipv6

) inherits ntp::params
{

    # IPv4 rules
    firewall { '008 ipv4 accept ntp':
        provider => 'iptables',
        chain  => 'INPUT',
        proto => 'udp',
        # Set the allowable source address, unless 'any', in which case the 
        # 'source' parameter is left undefined.
        source => $allow_address_ipv4 ? {
            'any' => undef,
            default => $allow_address_ipv4,
        },
        dport => 123,
        action => 'accept',
    }

    # IPv6 rules
    firewall { '008 ipv6 accept ntp':
        provider => 'ip6tables',
        chain  => 'INPUT',
        proto => 'udp',
        source => $allow_address_ipv6 ? {
            'any' => undef,
            default => $allow_address_ipv6,
        },
        dport => 123,
        action => 'accept',
    }
}

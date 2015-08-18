#
# == Class ntp::packetfilter
#
# Configures packetfiltering rules for ntpd
#
class ntp::packetfilter
(
    $ensure,
    $allow_address_ipv4,
    $allow_address_ipv6

) inherits ntp::params
{

    # IPv4 rules
    # Set the allowable source address, unless 'any', in which case the 'source' 
    # parameter is left undefined.
    $source_v4 = $allow_address_ipv4 ? {
        'any'   => undef,
        default => $allow_address_ipv4,
    }

    $ensure_firewall = $ensure ? {
        /(running|present)/ => 'present',
        'absent'            => 'absent',
    }

    firewall { '008 ipv4 accept ntp':
        ensure   => $ensure_firewall,
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'udp',
        source   => $source_v4,
        dport    => 123,
        action   => 'accept',
    }

    # IPv6 rules
    $source_v6 = $allow_address_ipv6 ? {
        'any'   => undef,
        default => $allow_address_ipv6,
    }

    firewall { '008 ipv6 accept ntp':
        ensure   => $ensure_firewall,
        provider => 'ip6tables',
        chain    => 'INPUT',
        proto    => 'udp',
        source   => $source_v6,
        dport    => 123,
        action   => 'accept',
    }
}

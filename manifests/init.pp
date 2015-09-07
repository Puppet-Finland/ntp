#
# == Class: ntp
#
# Install and configure ntp
#
# == Parameters
#
# [*manage*]
#   Whether to manage ntp with Puppet or not. Valid values are 'yes' (default) 
#   and 'no'.
# [*ensure*]
#   Status of ntpd. Valid values are 'running', 'present' (default) and 'absent'
# [*ntp_servers*]
#   An array containing a list of ntp servers to use. Only use this for static 
#   server address, not ntp pools: on RedHat-based operating systems having a 
#   ntp pool as the value for "server" directive will cause spontaneous ntpd 
#   restarts (signal 15), which drives things like monit crazy. The default 
#   value for this parameter is undef. This or the $ntp_pools parameter needs to 
#   be defined or catalog compilation will fail.
# [*ntp_pools*]
#   An array containing a list of ntp server _pools_ to use. Note that ntpd 
#   bundled with (most?) Debian-based operating systems and FreeBSD does not 
#   have the "pool" option, so any pools you define are converted into "server" 
#   lines instead. Defaults to undef.
# [*restrict_addresses*]
#   An array containing a list of addresses from which to allow connections to 
#   ntpd. Note that access from '127.0.0.1' and '::1' is automatically allowed. 
#   The format used is the same as for the "restrict" option in ntp.conf:
#
#     restrict address [mask mask] [flag][...]
#
#   for example [ '10.232.31.0 mask 255.255.255.0', 'server.domain.com' ]
#
#   Typically you'd define this parameter if the node is an ntp server serving 
#   time (e.g. for the LAN).
# [*allow_address_ipv4*]
#   IPv4 address/network from which to allow connections through the firewall.
#   Only affects packet filtering rules on nodes which have included the
#   'packetfilter' class. A special value, 'any', can be used to allow any hosts
#   from any IPv4 address to connect to this ntpd instance. Defaults to '127.0.0.1'.
# [*allow_address_ipv6*]
#   IPv6 address/network from which to allow connections through the firewall. 
#   The same options/limitations apply as for $allow_address_ipv4. Defaults to 
#   '::1'.
# [*peer*]
#   The address of a peer ntpd server. This is only needed if you want several 
#   ntpd servers to co-operate so that if a peer looses connectivity to external 
#   sources, it can still keep accurate time as long as at least one peer is 
#   connected to external clock sources. If $orphan_stratum parameter is used on 
#   this node and it's peer, the nodes become s.c. "orphan parents". This 
#   parameter is not needed for ntp clients, and not necessarily on ntp servers, 
#   either. The default is not to configure any peers.
# [*orphan_stratum*]
#   Configure ntpd to use the "orphan" mode with the given stratum. According to 
#   ntpd documentation the stratum should be higher than that of the external 
#   sources being used, but smaller than 16 - a value of 5 or so is suggested in 
#   some sources. If this parameter is defined, but the $peer parameter is not, 
#   then this node will become an "orphan child" for the server(s) defined in 
#   the $ntp_servers parameter. The default value is not to use orphan mode, 
#   which is what you want for simple ntp clients.
# [*monitor_email*]
#   Email address where local service monitoring software sends it's reports to.
#   Defaults to top scope variable $::servermonitor.
#
# == Examples
#
#   class { 'ntp':
#       ntp_servers => [ '0.fi.pool.ntp.org', '1.fi.pool.ntp.org' ]
#   }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class ntp
(
    $ensure = 'present',
    $manage = 'yes',
    $ntp_servers = undef,
    $ntp_pools = undef,
    $restrict_addresses = undef,
    $allow_address_ipv4 = '127.0.0.1',
    $allow_address_ipv6 = '::1',
    $peer = undef,
    $orphan_stratum = undef,
    $monitor_email = $::servermonitor
)
{

if $manage == 'yes' {

    class { '::ntp::install':
        ensure => $ensure,
    }

    class { '::ntp::config':
        ensure             => $ensure,
        ntp_servers        => $ntp_servers,
        ntp_pools          => $ntp_pools,
        restrict_addresses => $restrict_addresses,
        peer               => $peer,
        orphan_stratum     => $orphan_stratum,
    }

    class { '::ntp::service':
        ensure => $ensure,
    }

    if tagged('packetfilter') {
        class { '::ntp::packetfilter':
            ensure             => $ensure,
            allow_address_ipv4 => $allow_address_ipv4,
            allow_address_ipv6 => $allow_address_ipv6,
        }
    }

    if tagged('monit') {
        class { '::ntp::monit':
            ensure        => $ensure,
            monitor_email => $monitor_email,
        }
    }
}
}

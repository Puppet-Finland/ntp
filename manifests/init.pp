#
# == Class: ntp
#
# Install and configure ntp
#
# == Parameters
#
# [*ntp_servers*]
#   An array containing a list of ntp servers to use. Defaults to global 
#   variable $ntp_servers.
# [*restrict_addresses*]
#   An array containing a list of addresses from which to allow connections to 
#   the ntpd, in the format used by ntp.conf "restrict" option, i.e.
#
#     restrict address [mask mask] [flag][...]
#
#   for example [ '10.232.31.0 mask 255.255.255.0', 'server.domain.com', ':1' ]
#
#   If the node is just an ntp client then the default value, [ '127.0.0.1', 
#   '::1' ] is adequate. If the node is an ntp server serving time (e.g. for a 
#   LAN), then make sure to allow connections from the appropriate addresses.
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
# class { 'ntp':
#   ntp_servers => [ '0.fi.pool.ntp.org', '1.fi.pool.ntp.org' ]
# }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
class ntp
(
    $ntp_servers = $::ntp_servers,
    $restrict_addresses = [ '127.0.0.1', '::1' ],
    $peer = '',
    $orphan_stratum = '',
    $monitor_email = $::servermonitor
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_ntp', 'true') != 'false' {

    include ntp::install

    class { 'ntp::config':
        ntp_servers => $ntp_servers,
        restrict_addresses => $restrict_addresses,
        peer => $peer,
        orphan_stratum => $orphan_stratum,
    }

    include ntp::service

    if tagged('monit') {
        class { 'ntp::monit':
            monitor_email => $monitor_email,
        }
    }
}
}

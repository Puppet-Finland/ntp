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
class ntp(
    $ntp_servers = $::ntp_servers,
    $restrict_addresses = [ '127.0.0.1', '::1' ],
    $monitor_email = $::servermonitor
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_ntp', 'true') != 'false' {

    include ntp::install

    class { 'ntp::config':
        ntp_servers => $ntp_servers,
        restrict_addresses => $restrict_addresses,
    }

    include ntp::service

    if tagged('monit') {
        class { 'ntp::monit':
            monitor_email => $monitor_email,
        }
    }
}
}

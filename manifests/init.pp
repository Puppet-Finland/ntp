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
    $monitor_email = $::servermonitor
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_ntp') != 'false' {

    include ntp::install

    class { 'ntp::config':
        ntp_servers => $ntp_servers
    }

    include ntp::service

    if tagged('monit') {
        class { 'ntp::monit':
            monitor_email => $monitor_email,
        }
    }
}
}

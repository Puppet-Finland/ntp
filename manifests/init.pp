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
    $ntp_servers = $::ntp_servers
)
{
    include ntp::install

    class { 'ntp::config':
        ntp_servers => $ntp_servers
    }

    include ntp::service

    if tagged('monit') {
        include ntp::monit
    }
}

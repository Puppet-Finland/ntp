#
# == Class: ntp::config
#
# Configure the ntp server
#
class ntp::config
(
    $ntp_servers,
    $peer,
    $orphan_stratum,
    $restrict_addresses
)
{
    include os::params
    include ntp::params

    # Check if a peer is defined (for servers)
    if $peer == '' {
        $peer_line = undef
    } else {
        $peer_line = "peer ${peer}"
    }

    # Check if orphan mode is activated (for servers)
    if $orphan_stratum == '' {
        $orphan_line = undef
    } else {
        $orphan_line = "tos orphan ${orphan_stratum}"
    }

    file { 'ntp-ntp.conf':
        name  => '/etc/ntp.conf',
        ensure => present,
        content => template('ntp/ntp.conf.erb'),
        owner => root,
        group => "${::os::params::admingroup}",
        mode  => 644,
        require => Class['ntp::install'],
        notify => Class['ntp::service'],
    }
}

#
# == Class: ntp::config
#
# Configure the ntp server
#
class ntp::config
(
    $ensure,
    $ntp_servers,
    $peer,
    $orphan_stratum,
    $restrict_addresses

) inherits ntp::params
{

    # Check that we have extra restrict lines
    if $restrict_addresses {
        $restrict_lines = $restrict_addresses
    } else {
        $restrict_lines = undef
    }

    # Check if a peer is defined (for servers)
    if $peer {
        $peer_line = "peer ${peer}"
    } else {
        $peer_line = undef
    }

    # Check if orphan mode is activated (for servers)
    if $orphan_stratum {
        $orphan_line = "tos orphan ${orphan_stratum}"
    } else {
        $orphan_line = undef
    }

    $ensure_file = $ensure ? {
        /(present|running)/ => 'present',
        'absent'            => 'absent',
    }

    file { 'ntp-ntp.conf':
        ensure  => $ensure_file,
        name    => '/etc/ntp.conf',
        content => template('ntp/ntp.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['ntp::install'],
        notify  => Class['ntp::service'],
    }
}

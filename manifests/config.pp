#
# == Class: ntp::config
#
# Configure the ntp server
#
class ntp::config($ntp_servers)
{
    file { 'ntp-ntp.conf':
        name  => '/etc/ntp.conf',
        ensure => present,
        content => template('ntp/ntp.conf.erb'),
        owner => root,
        group => root,
        mode  => 644,
        require => Class['ntp::install'],
        notify => Class['ntp::service'],
    }
}

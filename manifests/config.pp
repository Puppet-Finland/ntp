#
# == Class: ntp::config
#
# Configure the ntp server
#
class ntp::config($ntp_servers)
{
    include ntp::params

    file { 'ntp-ntp.conf':
        name  => '/etc/ntp.conf',
        ensure => present,
        content => template('ntp/ntp.conf.erb'),
        owner => root,
        group => "${::ntp::params::admingroup}",
        mode  => 644,
        require => Class['ntp::install'],
        notify => Class['ntp::service'],
    }
}

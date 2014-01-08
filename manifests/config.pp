#
# == Class: ntp::config
#
# Configure the ntp server
#
class ntp::config
(
    $ntp_servers,
    $restrict_addresses
)
{
    include os::params
    include ntp::params

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

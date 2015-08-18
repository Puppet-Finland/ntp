#
# == Class: ntp::service::redhat
#
# RedHat-specific ntp service configuration. In particular this class ensures 
# that ntpd creates a pidfile which we can monitor using monit.
#
class ntp::service::redhat
(
    $ensure

) inherits ntp::params
{

    $ensure_file = $ensure ? {
        /(present|running)/ => 'present',
        'absent'            => 'absent',
    }

    if $::osfamily == 'RedHat' {
        file { 'ntp':
            ensure  => $ensure_file,
            name    => '/etc/sysconfig/ntpd',
            content => template('ntp/ntp.erb'),
            owner   => $::os::params::adminuser,
            group   => $::os::params::admingroup,
            mode    => '0644',
            notify  => Class['ntp::service'],
        }
    }
}

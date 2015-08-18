#
# == Class: ntp::service
#
# Configures ntp to start on boot
#
class ntp::service
(
    $ensure

) inherits ntp::params {

    $ensure_service = $ensure ? {
        'running' => 'running',
        default   => undef,
    }

    $enable_service = $ensure ? {
        /(present|running)/ => true,
        'absent'            => false,
    }

    class { '::ntp::service::redhat':
        ensure => $ensure,
    }

    service { 'ntp':
        ensure    => $ensure_service,
        name      => $::ntp::params::service_name,
        enable    => $enable_service,
        hasstatus => $::ntp::params::service_hasstatus,
        require   => [ Class['ntp::config'], Class['ntp::service::redhat'] ],
    }

    if str2bool($::has_systemd) {
        systemd::service_fragment { 'ntp':
            ensure       => $ensure,
            service_name => $::ntp::params::service_name,
            pidfile      => $::ntp::params::pidfile,
        }
    }

}

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

    if $::systemd {
        $pidfile = $::ntp::params::pidfile
        $restart = 'no'

        ::systemd::dropin_file { 'ntp':
            ensure   => $ensure,
            unit     => "${::ntp::params::service_name}.service",
            content  => template('ntp/ntp.service.erb'),
            filename => 'puppet.conf',
            mode     => '0755',
        }
    }
}

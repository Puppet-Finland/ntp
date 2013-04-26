#
# == Class: ntp::service
#
# Configures ntp to start on boot
#
class ntp::service {

    include ntp::params

	service { 'ntp':
        name      => $ntp::params::service_name,
        enable    => true,
        hasstatus => $ntp::params::service_hasstatus,
        require   => Class['ntp::config'],
    }
}

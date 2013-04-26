#
# == Class: ntp::params
#
# Defines some variables based on the operating system
#
class ntp::params {

    $service_name = $::osfamily ? {
        'RedHat' => 'ntpd',
        'Debian' => 'ntp',
        default  => 'ntp',
    }

    $service_command = $::osfamily ? {
        default => "/usr/sbin/service $service_name",
    }

    $service_hasstatus = $::lsbdistcodename ? {
        default => 'true',
    }
}

#
# == Class: ntp::params
#
# Defines some variables based on the operating system
#
class ntp::params {

    case $::osfamily {
        'RedHat': {
            $service_name = 'ntpd'
            $service_command = "/sbin/service $service_name"  
        }
        'Debian': {
            $service_name = 'ntp'
            $service_command = "/usr/sbin/service $service_name"
        }
        'Ubuntu': {
            $service_name = 'ntp'
            $service_command = "/usr/sbin/service $service_name"
        }
        default: {
            $service_name = 'ntp'
            $service_command = "/usr/sbin/service $service_name"
        }
    }

    # This can be used to work around startup scripts that don't have a proper
    # "status" target.
    $service_hasstatus = $::lsbdistcodename ? {
        default => 'true',
    }
}

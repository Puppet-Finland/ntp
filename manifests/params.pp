#
# == Class: ntp::params
#
# Defines some variables based on the operating system
#
class ntp::params {

    case $::osfamily {
        'RedHat': {
            $driftfile = '/var/lib/ntp/ntp.drift'
            $service_name = 'ntpd'
            $service_command = "/sbin/service $service_name"  
            $admingroup = 'root'
        }
        'Debian': {
            $driftfile = '/var/lib/ntp/ntp.drift'
            $service_name = 'ntp'
            $service_command = "/usr/sbin/service $service_name"
            $admingroup = 'root'
        }
        'Ubuntu': {
            $driftfile = '/var/lib/ntp/ntp.drift'
            $service_name = 'ntp'
            $service_command = "/usr/sbin/service $service_name"
            $admingroup = 'root'
        }
        'FreeBSD': {
            $driftfile = '/var/db/ntpd.drift'
            $service_name = 'ntpd'
            $service_command = "/etc/rc.d/$service_name"
            $admingroup = 'wheel'
        }
        default: {
            $driftfile = '/var/lib/ntp/ntp.drift'
            $service_name = 'ntp'
            $service_command = "/usr/sbin/service $service_name"
            $admingroup = 'root'
        }
    }

    # This can be used to work around startup scripts that don't have a proper
    # "status" target.
    $service_hasstatus = $::lsbdistcodename ? {
        default => 'true',
    }
}

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

            if $::operatingsystem == 'Fedora' {
                $service_start = "/usr/bin/systemctl start ${service_name}.service"
                $service_stop = "/usr/bin/systemctl stop ${service_name}.service"
            } else {
                $service_start = "/sbin/service $service_name start"  
                $service_stop = "/sbin/service $service_name stop"
            }

        }
        'Debian': {
            $driftfile = '/var/lib/ntp/ntp.drift'
            $service_name = 'ntp'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
        }
        'FreeBSD': {
            $driftfile = '/var/db/ntpd.drift'
            $service_name = 'ntpd'
            $service_start = "/etc/rc.d/$service_name start"
            $service_stop = "/etc/rc.d/$service_name stop"
        }
        default: {
            $driftfile = '/var/lib/ntp/ntp.drift'
            $service_name = 'ntp'
            $service_command = "/usr/sbin/service $service_name"
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
        }
    }

    # This can be used to work around startup scripts that don't have a proper
    # "status" target.
    $service_hasstatus = $::lsbdistcodename ? {
        default => 'true',
    }
}

#
# == Class: ntp::params
#
# Defines some variables based on the operating system
#
class ntp::params {

    include ::os::params

    case $::osfamily {
        'RedHat': {
            $driftfile = '/var/lib/ntp/ntp.drift'
            $service_name = 'ntpd'
        }
        'Debian': {
            $driftfile = '/var/lib/ntp/ntp.drift'
            $service_name = 'ntp'
        }
        'FreeBSD': {
            $driftfile = '/var/db/ntpd.drift'
            $service_name = 'ntpd'
        }
        default: {
            fail("Unsupported operating system ${::osfamily}")
        }
    }

    if str2bool($::has_systemd) {
        $service_start = "${::os::params::systemctl} start ${service_name}"
        $service_stop = "${::os::params::systemctl} stop ${service_name}"
    } else {
        $service_start = "${::os::params::service_cmd} ${service_name} start"
        $service_stop = "${::os::params::service_cmd} ${service_name} stop"
    }

    # This can be used to work around startup scripts that don't have a proper
    # "status" target.
    $service_hasstatus = $::lsbdistcodename ? {
        default => true,
    }
}

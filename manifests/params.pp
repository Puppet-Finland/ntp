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
            $pidfile = '/var/run/ntpd.pid'
            $service_name = 'ntpd'
            $service_opts = $::operatingsystemmajrelease ? {
                6       => "-p ${pidfile} -g -u ntp:ntp",
                7       => "-p ${pidfile} -g",
                21      => "-p ${pidfile} -g",
                default => "-p ${pidfile} -g",
            }
            $pool_directive = 'pool'
        }
        'Debian': {
            $driftfile = '/var/lib/ntp/ntp.drift'
            $pidfile = '/var/run/ntpd.pid'
            $service_name = 'ntp'
            $pool_directive = 'server'
        }
        'FreeBSD': {
            $driftfile = '/var/db/ntpd.drift'
            $pidfile = '/var/run/ntpd.pid'
            $service_name = 'ntpd'
            $pool_directive = 'server'
        }
        default: {
            fail("Unsupported operating system ${::osfamily}")
        }
    }

    if $::systemd {
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

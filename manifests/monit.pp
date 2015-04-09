#
# == Class: ntp::monit
#
# Setups monit rules for ntp
#
class ntp::monit
(
    $monitor_email

) inherits ntp::params
{
    monit::fragment { 'ntp-ntp.monit':
        modulename => 'ntp',
    }
}

#
# == Class: ntp::monit
#
# Setups monit rules for ntp
#
class ntp::monit
(
    $ensure,
    $monitor_email

) inherits ntp::params
{
    monit::fragment { 'ntp-ntp.monit':
        ensure     => $ensure,
        basename   => 'ntp',
        modulename => 'ntp',
    }
}

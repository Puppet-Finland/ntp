#
# == Class: ntp::monit
#
# Setups monit rules for ntp
#
class ntp::monit(
    $monitor_email
)
{
    monit::fragment { 'ntp-ntp.monit':
        modulename => 'ntp',
    }
}

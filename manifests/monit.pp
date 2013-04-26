#
# == Class: ntp::monit
#
# Setups monit rules for ntp
#
class ntp::monit {
    monit::fragment { 'ntp-ntp.monit':
        modulename => 'ntp',
    }
}

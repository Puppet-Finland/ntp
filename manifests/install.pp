# == Class: ntp::install
#
# Install the ntp package
#
class ntp::install inherits ntp::params {

    if $::osfamily == 'FreeBSD' {
        # We do nothing, as ntpd is always installed. We still need to include 
        # this class to satisfy dependencies in the ntp::config class.
    } else {
        package { 'ntp-ntp':
            name => 'ntp',
            ensure => installed,
        }
    }
}

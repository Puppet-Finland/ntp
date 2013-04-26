# == Class: ntp::install
#
# Install the ntp package
#
class ntp::install {
    package { 'ntp-ntp':
        name => 'ntp',
        ensure => installed,
    }
}

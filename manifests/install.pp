# == Class: ntp::install
#
# Install the ntp package
#
class ntp::install
(
    $ensure

) inherits ntp::params {

    $ensure_package = $ensure ? {
        /(present|running)/ => 'present',
        'absent'            => 'absent'
    }

    if $::osfamily == 'FreeBSD' {
        # We do nothing, as ntpd is always installed. We still need to include 
        # this class to satisfy dependencies in the ntp::config class.
    } else {
        package { 'ntp-ntp':
            ensure => $ensure_package,
            name   => 'ntp',
        }
    }
}

#
# == Class: ntp::config::redhat
#
# Configurations specific to RedHat family of operating systems
#
class ntp::config::redhat {

    # If this file is not removed, bad things happen:
    #
    # - dhclient-script adds ntp server(s) obtained from DHCP to ntp.conf
    # - puppet fixes ntp.conf
    # - puppet restarts ntpd
    # - monit notices the pid change and sends a (useless) email to the
    #   monitoring address
    #
    # This sequence of events makes it look like ntpd is crashing or
    # restarting spontaneously.
    #
    file { 'ntp-ntp.sh':
        ensure  => absent,
        name    => '/etc/dhcp/dhclient.d/ntp.sh',
        require => Class['ntp::install'],
    }
}

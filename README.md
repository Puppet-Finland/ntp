ntp
===

A Puppet module for installing and configuring ntp. Comes with optional 
iptables/ip6tables and monit support.

# Module usage

Simple usage to keep the clock synchronized:

    class { '::ntp':
      ntp_servers => ['0.us.pool.ntp.org',
                      '1.us.pool.ntp.org',
                      '2.us.pool.ntp.org',
                      '3.us.pool.ntp.org',
                     ],
    }

Configure ntpd to serve other hosts as an ntp proxy. Access is restricted by IP 
by both ntpd itself ($restrict_addresses) and by iptables ($allow_address_ipv4):

    class { '::ntp':
      allow_address_ipv4 => '10.0.0.0/8',
      orphan_stratum     => 12,
      restrict_addresses => [ '10.0.0.0 mask 255.0.0.0' ],
      peer               => '10.110.40.5',
      ntp_servers => ['0.us.pool.ntp.org',
                      '1.us.pool.ntp.org',
                      '2.us.pool.ntp.org',
                      '3.us.pool.ntp.org',
                     ],
    }

The $peer is the another proxy with which this ntpd instance communicates with. 
This helps maintain clock syncing if external sources ($ntp_servers) become 
unresponsive.

For detail see [init.pp](manifests/init.pp).

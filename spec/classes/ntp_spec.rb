# frozen_string_literal: true

require 'spec_helper'

describe 'ntp' do
  let(:params) do
    {
      'monitor_email' => 'root@localhost',
      'ntp_servers'   => ['8.8.8.8', '8.8.4.4'],
    }
  end

  let(:pre_condition) do
    [
      'include epel',
      'include os::params',
      'include systemd',
      'class { "monit": email => "root@localhost" }',
    ]
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      # All supported operating systems do not have systemd, but we don't want
      # to enumerate every single operating system combination here, either.
      extra_facts = if os_facts[:osfamily] == 'RedHat'
                      { systemd: true, lsbdistcodename: 'RedHat' }
                    else
                      { systemd: true }
                    end

      let(:facts) { os_facts.merge(extra_facts) }

      let(:params) { super() }

      let(:pre_condition) { super() }

      it { is_expected.to compile }
    end
  end

  bionic = { supported_os: [{ 'operatingsystem' => 'Ubuntu', 'operatingsystemrelease' => ['18.04'] }] }

  on_supported_os(bionic).each do |_os, os_facts|
    context 'test service fragment' do
      let(:facts) { os_facts.merge(systemd: true) }

      let(:params) { super() }

      let(:pre_condition) { super() }

      it { is_expected.to contain_file('/etc/systemd/system/ntp.service.d/puppet.conf').with(path: '/etc/systemd/system/ntp.service.d/puppet.conf') }
    end
  end
end

require 'spec_helper'

describe 'hyperic::rpm_gpg_key', :type => :define do
  context 'supported vfabric versions' do
    ['5.1', '5.2', '5.3'].each do |vfabric_version|
      context "version #{vfabric_version}" do
        ['5', '6'].each do |os_version|
          context "on EL#{os_version} " do
            let(:facts) {{ :operatingsystemmajrelease => os_version }}
            let(:params) {{ :path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-#{vfabric_version}-EL#{os_version}" }}
            let(:title) { "VFABRIC-#{vfabric_version}-EL#{os_version}" }
            it { should contain_exec("import-#{title}").with(
              'path'      => '/bin:/usr/bin:/sbin:/usr/sbin',
              'command'   => "rpm --import #{params[:path]}",
              'unless'    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids < #{params[:path]}) | cut --characters=11-18 | tr '[A-Z]' '[a-z]')",
              'require'   => "File[#{params[:path]}]",
              'logoutput' => 'on_failure'
            )}
          end
        end
      end
    end
    context "version 5 (EL5 only)" do
      let(:params) {{ :path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-5" }}
      let(:title) { "VFABRIC-5" }
      it { should contain_exec("import-#{title}").with(
        'path'      => '/bin:/usr/bin:/sbin:/usr/sbin',
        'command'   => "rpm --import #{params[:path]}",
        'unless'    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids < #{params[:path]}) | cut --characters=11-18 | tr '[A-Z]' '[a-z]')",
        'require'   => "File[#{params[:path]}]",
        'logoutput' => 'on_failure'
      )}
    end
  end
end

require 'spec_helper'

describe 'hyperic' do
  context 'on supported operating systems' do
    context 'without any parameters' do
      let(:params) {{ }}
      let(:facts) {{
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '6',
      }}
      it { should compile.with_all_deps }

      it { should contain_class('hyperic::params') }
      it { should contain_class('hyperic::repo').that_comes_before('hyperic::install') }
      it { should contain_class('hyperic::install').that_comes_before('hyperic::config') }
      it { should contain_class('hyperic::config') }
      it { should contain_class('hyperic::service').that_subscribes_to('hyperic::config') }

      it { should contain_group('vfabric').with(
        :ensure => 'present',
        :system => 'true'
      )}
      it { should contain_user('hyperic').with(
        :ensure => 'present',
        :system => 'true',
        :home   => '/opt/hyperic',
        :shell  => '/sbin/nologin',
        :gid    => 'vfabric'
      )}

      it { should contain_service('hyperic-hqee-agent').with(
        :ensure => 'running',
        :enable => 'true'
      )}
      it { should contain_package('vfabric-hyperic-agent').with_ensure('latest') }

      it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camIP=localhost/) }
      it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camPort=7080/) }
      it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camSSLPort=7443/) }
      it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camSecure=yes/) }
      it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camLogin=hqadmin/) }
      it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/B2s1HN610w==/) }
      it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.scu').with_content(/vhpNo3TaTQ4jJ0MslmIgcaPD3TA5urZouiBVBCUJ5rjBXLGHLEjtOI/) }
      it { should contain_file('/etc/init.d/hyperic-hqee-agent').with_content(/# Short-Description: hyperic-hqee-agent init/) }
      it { should contain_file('/etc/yum.repos.d/vfabric.repo') }

      ['5', '6'].each do |os_major_version|
        context "on EL#{os_major_version}" do
          let(:params) {{ }}
          let(:facts) {{
            :osfamily                  => 'RedHat',
            :operatingsystemmajrelease => os_major_version,
          }}

          it { should contain_file("/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-5.3-EL#{facts[:operatingsystemmajrelease]}") }

          it { should contain_hyperic__rpm_gpg_key("VFABRIC-5.3-EL#{facts[:operatingsystemmajrelease]}").with_path("/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-5.3-EL#{facts[:operatingsystemmajrelease]}") }

          it { should contain_yumrepo('vfabric').with(
            :descr    => 'VMWare vFabric 5.3 - $basearch',
            :enabled  => '1',
            :gpgcheck => '1',
            :gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-5.3-EL#{facts[:operatingsystemmajrelease]}",
            :baseurl  => "http://repo.vmware.com/pub/rhel#{facts[:operatingsystemmajrelease]}/vfabric/5.3/$basearch"
          )}
        end
      end
    end
    context 'with custom parameters' do
      let(:facts) {{
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '6'
      }}
      context 'agent group name' do
        let(:params) {{ 'agent_group' => 'custom_group' }}
        it { should contain_group("#{params['agent_group']}") }
      end
      context 'agent version' do
        let(:params) {{ 'agent_version' => '5.7.1.EE-1' }}
        it { should contain_package('vfabric-hyperic-agent').with_ensure("#{params['agent_version']}") }
      end
      context 'agent user name' do
        let(:params) {{ 'agent_user' => 'custom_user' }}
        it { should contain_user("#{params['agent_user']}") }
      end
      context 'JAVA_HOME' do
        let(:params) {{ 'java_home' => '/usr/lib/jvm/java-6-openjdk/jre' }}
        it { should contain_file('/etc/init.d/hyperic-hqee-agent').with_content(/java-6-openjdk/) }
      end
      context 'package name' do
        let(:params) {{ 'package_name' => 'custom-package' }}
        it { should contain_package("#{params['package_name']}") }
      end
      context 'repo path' do
        let(:params) {{ 'repo_path' => 'http://some.custom.repo/path/' }}
        it { should contain_yumrepo('vfabric').with(
          :descr    => 'VMWare vFabric 5.3 - $basearch',
          :enabled  => '1',
          :gpgcheck => '1',
          :gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-5.3-EL#{facts[:operatingsystemmajrelease]}",
          :baseurl  => "#{params['repo_path']}rhel#{facts[:operatingsystemmajrelease]}/vfabric/5.3/$basearch"
        )}
      end
      context 'server encrypted key' do
        let(:params) {{ 'server_enc_key' => 'thiskeyisalmostascoolasadogwearingsunglasses' }}
        it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.scu').with_content(/thiskeyisalmostascoolasadogwearingsunglasses/) }
      end
      context 'server encrypted password' do
        let(:params) {{ 'server_enc_pw' => 'myreallycoolcustompassword' }}
        it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/myreallycoolcustompassword/) }
      end
      context 'server ip' do
        let(:params) {{ 'server_ip' => '1.2.3.4' }}
        it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camIP=1.2.3.4/) }
      end
      context 'server ip' do
        let(:params) {{ 'server_ip' => '1.2.3.4' }}
        it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camIP=1.2.3.4/) }
      end
      context 'server login' do
        let(:params) {{ 'server_login' => 'customhquser' }}
        it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camLogin=customhquser/) }
      end
      context 'server port' do
        let(:params) {{ 'server_port' => '1234' }}
        it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camPort=1234/) }
      end
      context 'server secure' do
        let(:params) {{ 'server_secure' => 'no' }}
        it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camSecure=no/) }
      end
      context 'server ssl port' do
        let(:params) {{ 'server_ssl_port' => '5678' }}
        it { should contain_file('/opt/hyperic/hyperic-hqee-agent/conf/agent.properties').with_content(/agent.setup.camSSLPort=5678/) }
      end
      context 'service name' do
        let(:params) {{ 'service_name' => 'custom-service' }}
        it { should contain_service("#{params['service_name']}") }
        it { should contain_file("/etc/init.d/#{params['service_name']}").with_content(/# Short-Description: custom-service init/) }
      end
      context 'repo disabled' do
        let(:params) {{ 'enable_repo' => false }}
        it { should contain_yumrepo('vfabric').with(
          :enabled  => '0'
        )}
        it { should contain_package('vfabric-hyperic-agent').with_ensure('present') }
      end
      context 'repo disabled' do
        let(:params) {{ 'manage_repo' => false }}
        it { should_not contain_yumrepo('vfabric') }
        it { should_not contain_file('/etc/yum.repos.d/vfabric.repo') }
        it { should_not contain_file("/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-5.3-EL#{facts[:operatingsystemmajrelease]}") }
      end
      context 'supported vfabric versions' do
        ['5.1', '5.2', '5.3'].each do |vfabric_version|
          context "version #{vfabric_version}" do
            ['5', '6'].each do |os_version|
              context " on EL#{os_version}" do
                let(:facts) {{
                  :osfamily                  => 'RedHat',
                  :operatingsystemmajrelease => os_version
                }}
                let(:params) {{ 'vfabric_version' => vfabric_version }}
                it { should contain_file("/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-#{params['vfabric_version']}-EL#{facts[:operatingsystemmajrelease]}") }

                it { should contain_hyperic__rpm_gpg_key("VFABRIC-#{params['vfabric_version']}-EL#{facts[:operatingsystemmajrelease]}").with_path("/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-#{params['vfabric_version']}-EL#{facts[:operatingsystemmajrelease]}") }

                it { should contain_yumrepo('vfabric').with(
                  :descr    => "VMWare vFabric #{params['vfabric_version']} - $basearch",
                  :enabled  => '1',
                  :gpgcheck => '1',
                  :gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-#{params['vfabric_version']}-EL#{facts[:operatingsystemmajrelease]}",
                  :baseurl  => "http://repo.vmware.com/pub/rhel#{facts[:operatingsystemmajrelease]}/vfabric/#{params['vfabric_version']}/$basearch"
                )}
              end
            end
          end
        end
        context "version 5 (EL5 only)" do
          let(:facts) {{
            :osfamily                  => 'RedHat',
            :operatingsystemmajrelease => '5'
          }}
          let(:params) {{ 'vfabric_version' => '5' }}
          it { should contain_file("/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-#{params['vfabric_version']}") }

          it { should contain_hyperic__rpm_gpg_key("VFABRIC-#{params['vfabric_version']}").with_path("/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-#{params['vfabric_version']}") }

          it { should contain_yumrepo('vfabric').with(
            :descr    => "VMWare vFabric #{params['vfabric_version']} - $basearch",
            :enabled  => '1',
            :gpgcheck => '1',
            :gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-#{params['vfabric_version']}",
            :baseurl  => "http://repo.vmware.com/pub/rhel#{facts[:operatingsystemmajrelease]}/vfabric/#{params['vfabric_version']}/$basearch"
          )}
        end
      end
    end
  end
  context 'unsupported operating system' do
    context 'hyperic class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('vfabric-hyperic-agent') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end

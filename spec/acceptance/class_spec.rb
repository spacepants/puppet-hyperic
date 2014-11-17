require 'spec_helper_acceptance'

describe 'hyperic class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      java = <<-EOS
      class { 'java':
        distribution => 'jre',
      }
      EOS
      apply_manifest(java, :catch_failures => true)

      pp = <<-EOS
      class { 'hyperic': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('vfabric-hyperic-agent') do
      it { is_expected.to be_installed }
    end

    describe service('hyperic-hqee-agent') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end

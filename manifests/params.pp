# == Class hyperic::params
#
# This class is meant to be called from hyperic
# It sets variables according to platform
#
class hyperic::params {
  case $::osfamily {
    'RedHat': {
      $agent_group     = 'vfabric'
      $agent_user      = 'hyperic'
      $agent_version   = 'latest'
      $enable_repo     = true
      $java_home       = '/usr/lib/jvm/jre'
      $manage_repo     = true
      $package_name    = 'vfabric-hyperic-agent'
      $repo_path       = 'http://repo.vmware.com/pub/'
      $server_ip       = 'localhost'
      $server_port     = '7080'
      $server_ssl_port = '7443'
      $server_secure   = 'yes'
      $server_login    = 'hqadmin'
      $server_enc_pw   = 'sObldeOAPhM/B2s1HN610w=='
      $server_enc_key  = 'vhpNo3TaTQ4jJ0MslmIgcaPD3TA5urZouiBVBCUJ5rjBXLGHLEjtOI/yz/hPCQO/GYy9CBg9eMoWOmWcmg6c4Q\=\='
      $service_name    = 'hyperic-hqee-agent'
      $vfabric_version = '5.3'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}

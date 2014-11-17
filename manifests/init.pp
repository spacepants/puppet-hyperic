# == Class: hyperic
#
# Module to install an up-to-date version of Hyperic from VMWare repo.
#
# === Parameters
#
# [*agent_group*]
#   Group the hyperic agent should run as
#   Defaults to vfabric
#
# [*agent_version*]
#   Version of the hyperic agent to install
#   Defaults to latest
#
# [*agent_user*]
#   User the hyperic agent should run as
#   Defaults to hyperic
#
# [*enable_repo*]
#   Enable the VMWare vFabric repo
#   Defaults to true
#
# [*java_home*]
#   Path to $JAVA_HOME that Hyperic should use
#   Defaults to /usr/lib/jvm/jre
#
# [*manage_repo*]
#   Enable repo management
#   Defaults to true
#
# [*package_name*]
#   Name of the package to install
#   Defaults to vfabric-hyperic-agent
#
# [*repo_path*]
#   Path to the VMWare vFabric repo
#   Defaults to http://repo.vmware.com/pub/
#
# [*server_ip*]
#   IP address of the Hyperic server
#   Defaults to localhost
#
# [*server_port*]
#   Non-SSl port of the Hyperic server
#   Defaults to 7080
#
# [*server_ssl_port*]
#   SSl port of the Hyperic server
#   Defaults to 7443
#
# [*server_secure*]
#   Should the agent use SSL
#   Defaults to yes
#
# [*server_login*]
#   Login username of the Hyperic agent
#   Defaults to hqadmin
#
# [*server_enc_pw*]
#   Encrypted password of the Hyperic agent
#   Defaults to sObldeOAPhM/B2s1HN610w== (which is just hqadmin encrypted)
#
# [*server_enc_key*]
#   Encryption key of the Hyperic agent
#   Defaults to vhpNo3TaTQ4jJ0MslmIgcaPD3TA5urZouiBVBCUJ5rjBXLGHLEjtOI/yz/hPCQO/GYy9CBg9eMoWOmWcmg6c4Q\=\=
#
# [*service_name*]
#   Name of the service to use
#   Defaults to hyperic-hqee-agent
#
# [*vfabric_version*]
#   vFabric version to use
#   Defaults to 5.3
#
class hyperic (
  $agent_group     = $::hyperic::params::agent_group,
  $agent_version   = $::hyperic::params::agent_version,
  $agent_user      = $::hyperic::params::agent_user,
  $enable_repo     = $::hyperic::params::enable_repo,
  $java_home       = $::hyperic::params::java_home,
  $manage_repo     = $::hyperic::params::manage_repo,
  $package_name    = $::hyperic::params::package_name,
  $repo_path       = $::hyperic::params::repo_path,
  $server_ip       = $::hyperic::params::server_ip,
  $server_port     = $::hyperic::params::server_port,
  $server_ssl_port = $::hyperic::params::server_ssl_port,
  $server_secure   = $::hyperic::params::server_secure,
  $server_login    = $::hyperic::params::server_login,
  $server_enc_pw   = $::hyperic::params::server_enc_pw,
  $server_enc_key  = $::hyperic::params::server_enc_key,
  $service_name    = $::hyperic::params::service_name,
  $vfabric_version = $::hyperic::params::vfabric_version,
) inherits ::hyperic::params {

  validate_bool($enable_repo)
  validate_bool($manage_repo)
  validate_string($agent_version)
  validate_string($vfabric_version)

  class { '::hyperic::repo': } ->
  class { '::hyperic::install': } ->
  class { '::hyperic::config': } ~>
  class { '::hyperic::service': } ->
  Class['::hyperic']
}

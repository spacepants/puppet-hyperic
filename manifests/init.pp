# == Class: hyperic
#
# Full description of class hyperic here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
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

  # validate parameters here

  class { '::hyperic::repo': } ->
  class { '::hyperic::install': } ->
  class { '::hyperic::config': } ~>
  class { '::hyperic::service': } ->
  Class['::hyperic']
}

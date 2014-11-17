# == Class hyperic::install
#
class hyperic::install {
  group { $::hyperic::agent_group:
    ensure => present,
    system => true,
  }
  user { $::hyperic::agent_user:
    ensure => present,
    system => true,
    home   => '/opt/hyperic',
    shell  => '/sbin/nologin',
    gid    => 'vfabric'
  }
  if $::hyperic::enable_repo {
    package { $::hyperic::package_name:
      ensure   => $::hyperic::agent_version,
      provider => yum,
      require  => Yumrepo['vfabric']
    }
  } else {
    package { $::hyperic::package_name:
      ensure   => present
    }
  }
}

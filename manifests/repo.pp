# == Class hyperic::repo
#
# This class is called from hyperic
#
class hyperic::repo {
  if $::hyperic::manage_repo {
    file { '/etc/yum.repos.d/vfabric.repo':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
    case $::hyperic::vfabric_version {
      '5': {
        file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-${::hyperic::vfabric_version}":
          ensure => file,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          source => "puppet:///modules/hyperic/RPM-GPG-KEY-VFABRIC-${::hyperic::vfabric_version}"
        }
        if $::hyperic::enable_repo {
          yumrepo { 'vfabric':
            ensure   => present,
            descr    => "VMWare vFabric ${::hyperic::vfabric_version} - \$basearch",
            enabled  => '1',
            gpgcheck => '1',
            gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-${::hyperic::vfabric_version}",
            baseurl  => "${::hyperic::repo_path}rhel${::operatingsystemmajrelease}/vfabric/${::hyperic::vfabric_version}/\$basearch"
          }
        } else {
          yumrepo { 'vfabric':
            ensure   => present,
            descr    => "VMWare vFabric ${::hyperic::vfabric_version} - \$basearch",
            enabled  => '0',
            gpgcheck => '1',
            gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-${::hyperic::vfabric_version}",
            baseurl  => "${::hyperic::repo_path}rhel${::operatingsystemmajrelease}/vfabric/${::hyperic::vfabric_version}/\$basearch"
          }
        }
        hyperic::rpm_gpg_key{ "VFABRIC-${::hyperic::vfabric_version}":
          path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-${::hyperic::vfabric_version}",
          before => Yumrepo['vfabric'],
        }
      }
      default: {
        file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-${::hyperic::vfabric_version}-EL${::operatingsystemmajrelease}":
          ensure => file,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          source => "puppet:///modules/hyperic/RPM-GPG-KEY-VFABRIC-${::hyperic::vfabric_version}-EL${::operatingsystemmajrelease}"
        }
        if $::hyperic::enable_repo {
          yumrepo { 'vfabric':
            ensure   => present,
            descr    => "VMWare vFabric ${::hyperic::vfabric_version} - \$basearch",
            enabled  => '1',
            gpgcheck => '1',
            gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-${::hyperic::vfabric_version}-EL${::operatingsystemmajrelease}",
            baseurl  => "${::hyperic::repo_path}rhel${::operatingsystemmajrelease}/vfabric/${::hyperic::vfabric_version}/\$basearch"
          }
        } else {
          yumrepo { 'vfabric':
            ensure   => present,
            descr    => "VMWare vFabric ${::hyperic::vfabric_version} - \$basearch",
            enabled  => '0',
            gpgcheck => '1',
            gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-${::hyperic::vfabric_version}-EL${::operatingsystemmajrelease}",
            baseurl  => "${::hyperic::repo_path}rhel${::operatingsystemmajrelease}/vfabric/${::hyperic::vfabric_version}/\$basearch"
          }
        }
        hyperic::rpm_gpg_key{ "VFABRIC-${::hyperic::vfabric_version}-EL${::operatingsystemmajrelease}":
          path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-${::hyperic::vfabric_version}-EL${::operatingsystemmajrelease}",
          before => Yumrepo['vfabric'],
        }
      }
    }
  } else {
    # Don't do anything if we're not managing the repo.
  }
}
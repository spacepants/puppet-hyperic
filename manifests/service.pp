# == Class hyperic::service
#
# This class is meant to be called from hyperic
# It ensure the service is running
#
class hyperic::service {
  file { "/etc/init.d/${::hyperic::service_name}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('hyperic/hyperic.init.erb')
  }
  service { $::hyperic::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}

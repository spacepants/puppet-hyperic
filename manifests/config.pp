# == Class hyperic::config
#
# This class is called from hyperic
#
class hyperic::config {
  file { '/opt/hyperic/hyperic-hqee-agent/conf/agent.properties':
    ensure  => file,
    owner   => $::hyperic::agent_user,
    group   => $::hyperic::agent_group,
    mode    => '0644',
    content => template('hyperic/agent.properties.erb')
  }
  file { '/opt/hyperic/hyperic-hqee-agent/conf/agent.scu':
    ensure  => file,
    owner   => $::hyperic::agent_user,
    group   => $::hyperic::agent_group,
    mode    => '0600',
    content => template('hyperic/agent.scu.erb')
  }
}

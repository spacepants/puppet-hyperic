# Hyperic Puppet Module [![Build Status](https://secure.travis-ci.org/spacepants/puppet-hyperic.svg)](https://travis-ci.org/spacepants/puppet-hyperic)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with hyperic](#setup)
    * [What hyperic affects](#what-hyperic-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hyperic](#beginning-with-hyperic)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Puppet module for installing, configuring, and managing [VMWare's Hyperic OS & application monitoring agent](http://www.vmware.com/products/vrealize-hyperic) from the [official VMWare repository](http://repo.vmware.com/pub/).

## Module Description

This module manages the installation of the Hyperic agent and allows you to automatically deploy the latest version of the agent to your machines and configure the agent to report in to your server.

If you'd prefer, you can also disable the repo after the agent's been installed, or opt out of repo management altogether.

Note that you'll need your preferred distro of Java on the machine. While it isn't a direct dependency, the puppetlabs-java module works well for this purpose.

## Setup

### What hyperic affects

By default, this module will:
* Create a hyperic user belonging to a vfabric group.
* Install the appropriate rpm gpg key for the latest (5.3) vFabric version.
* Set up the yum repository for vFabric 5.3.
* Install the vFabric Hyperic agent.
* Configure the agent.properties and agent.scu files.
* Set up and enable the Hyperic agent service.

### Beginning with hyperic

You'll need your preferred distro of Java on the machine. While it isn't a direct dependency, the puppetlabs-java module works well for this purpose.

By default, the Hyperic installer encrypts the agent password on first startup. By preencrypting both the password value in agent.properties and the key in agent.scu, we can ensure a stable value that puppet can manage. The included default parameters will set the password to its default of "hqadmin". To set this to the password for your server, you can either run

```shell
./bin/hq-agent.sh set-property agent.setup.camPword your-password-here
```

which will encrypt the appropriate values in agent.properties and agent.scu. Or you can just copy over values from one of your currently installed and configured machines.

## Usage

This module includes a single class:
```puppet
include 'hyperic'
```

You'll more than likely want to provide the appropriate values for your server including, as mentioned above, the encrypted password and key which you can do like so:
```puppet
class { 'hyperic':
  server_ip      => '1.2.3.4',
  server_login   => 'hq-username',
  server_enc_pw  => 'encrypted-password-here',
  server_enc_key => 'your-encrypted-key-here',
}
```

You'll probably also want to specify your $JAVA_HOME path, which you can do like so:
```puppet
class { 'hyperic':
  java_home => '/your/path/to/jre'
}
```

You can specify which versions of vFabric or the Hyperic agent to install like so:
```puppet
  class { 'hyperic':
  agent_version   => '4.6.6.1.EE-1',
  vfabric_version => '5.1',
}
```

You can specify a local mirror or alternative source of the repo like so:
```puppet
  class { 'hyperic':
  repo_path => 'http://path.to.your.local/repo/',
}
```

To disable the repo once the agent's been installed, you can specify it like so: _(Note that this will also change the package ensure parameter from 'latest' to 'present'.)_
```puppet
  class { 'hyperic':
  enable_repo => false,
}
```

To opt out of repo management altogether, you'd specify it like so:
```puppet
  class { 'hyperic':
  manage_repo => false,
}
```

If your Hyperic setup is a beautiful, unique snowflake, you can customize pretty much any parameter in agent.properties you need to like so:
```puppet
class { 'hyperic':
  server_ip       => '1.2.3.4',
  server_port     => '1234',
  server_secure   => 'no',
  server_ssl_port => '5678',
  server_login    => 'hq-username',
  server_enc_pw   => 'encrypted-password-here',
  server_enc_key  => 'your-encrypted-key-here',
}
```

## Reference

This module uses [stahnma's really nice rpm gpg key checker](https://github.com/stahnma/puppet-module-epel/blob/master/manifests/rpm_gpg_key.pp), which checks to see if the gpg key is already installed, and if not, installs it.

## Limitations

This module currently only works with vFabric version 5.1, 5.2, and 5.3 on RedHat and CentOS 5 and 6, and vFabric version 5 on RedHat and CentOS 5.

## Development

If you'd like to other features or anythign else, check out the contributing guidelines in CONTRIBUTING.md.



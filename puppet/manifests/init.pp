# Init puppet provisioner for Magento installation
# puppet config print modulepath
# inspired by https://github.com/monsieurbiz/vagrant-magento
# Starting mailcatcher command "mailcatcher --http-ip `hostname -I`"
Exec {
  path => [
    '/usr/local/bin',
    '/opt/local/bin',
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin'
  ],
  logoutput => false,
}


# Apache
class { "apache":
  server_name   => "${hostname}",
  document_root => "${document_root}${hostname}"
}

class { "mysql":
  db_root_password => "${db_root_password}",
  db_name          => "${db_name}",
  db_user          => "${db_user}",
  db_password      => "${db_password}"
}

class { 'nodejs':
  version => 'v0.10.25'
}

# Includes

# Standard library for some puppet packages
include stdlib

include server
include apache
include mysql

# Puppet Package from https://forge.puppetlabs.com/willdurand/nodejs
include nodejs
include redis
include php
include git
include tools
include mailcatcher

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

include server
include apache

# MySQL


# Includes
#include php
#include mailcatcher
#include git
#include tools
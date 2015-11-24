class magento::configuration {


  # create a directory for elasticsearch
  file { "/home/vagrant":
    ensure => directory,
  }

    # create a directory for elasticsearch
  -> file { "/home/vagrant/magento":
    ensure => directory,
  }

  # Create the configuration file
  -> file { "magento htaccess":
    path    => "/home/vagrant/magento/.htaccess",
    ensure  => present,
    content => template("magento/.htaccess")
  }

  -> file { "magento local.xml":
    path    => "/home/vagrant/magento/local.xml",
    ensure  => present,
    content => template("magento/local.xml")
  }

    # Create the vhost
  -> file { "init_magento":
    path    => "/usr/local/bin/init_magento.sh",
    ensure  => present,
    content => template("magento/init_magento.sh")
  }

  -> exec { "chmod modman init magento":
    cwd     => "/usr/local/bin",
    command => "chmod +x /usr/local/bin/init_magento.sh",
  }
}
class tools::docker {

  package { "software-properties-common":
    ensure => latest
  }
  -> exec { "add ppt":
    cwd => "/tmp",
    command => "add-apt-repository ppa:docker-maint/testing",
  }
  -> package { "docker.io":
    ensure => latest
  }
  -> exec { "add vagrant user to docker":
    cwd => "/tmp",
    command => 'usermod -aG docker "vagrant"',
  }

  # create a directory for elasticsearch
  -> file { "/home/docker":
    ensure => directory,
  }
  -> file { "/home/docker/elasticsearch":
    ensure => directory,
  }
  -> file { "/home/docker/elasticsearch/config":
    ensure => directory,
  }

  # Create the configuration file
  -> file { "elasticsearch-config":
    path => "/home/docker/elasticsearch/config/elasticsearch.yml",
    ensure => present,
    content => template("tools/elasticsearch.yml")
  }

  -> file { "/home/docker/mysql":
    ensure => directory,
  }

  # Create the docker restart script
  file { "docker-restart-script":
    path => "/usr/local/bin/docker-restart.sh",
    ensure => present,
    content => template("tools/docker-restart.sh")
  }

  -> exec { "chmod modman docker-restart-script":
    cwd     => "/usr/local/bin",
    command => "chmod +x /usr/local/bin/docker-restart.sh",
  }
}

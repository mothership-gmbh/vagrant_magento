class tools::selenium {

  package { ["openjdk-7-jre-headless"]:
    ensure => latest,
  }

    # create a directory for selenium
  -> file { "/opt/selenium":
    ensure => directory,
  }

  # SeleniumServer
  exec { "download selenium standalone server":
    creates => "/opt/selenium/selenium",
    cwd => "/tmp",
    command => "wget http://goo.gl/PJUZfa -O /opt/selenium/selenium",
  }

  # Create the selenium restart script
  file { "selenium-start.sh":
    path => "/usr/local/bin/selenium-start.sh",
    ensure => present,
    content => template("tools/selenium-start.sh")
  }

  -> exec { "chmod modman selenium":
    cwd     => "/usr/local/bin",
    command => "chmod +x /usr/local/bin/selenium-start.sh",
  }
}
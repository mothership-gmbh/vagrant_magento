class php () {

# Install package
  package { "php5":
    ensure => latest,
    require => [ Class['server'], Package['apache2']],
    notify => Service['apache2'],
  }

  -> file { "/etc/php5/apache2/conf.d/20-xdebug.ini":
    ensure => file,
    source => "puppet:///modules/php/xdebug.ini",
    notify => Service['apache2'],
    owner => "root",
    group => "root",
  }

  -> file { "/etc/php5/cli/conf.d/20-xdebug.ini":
    ensure => file,
    source => "puppet:///modules/php/xdebug.ini",
    notify => Service['apache2'],
    owner => "root",
    group => "root",
  }

  -> file { "/etc/php5/apache2/php.ini":
    ensure => file,
    source => "puppet:///modules/php/php.ini",
    notify => Service['apache2'],
    owner => "root",
    group => "root",
  }

# Install modules
  $modules = [
    "php5-cli",
    "php5-common",
    "php5-gd",
    "php5-mysql",
    "php5-curl",
    "php5-intl",
    "php5-mcrypt",
    "php5-tidy",
    "php5-xdebug",

  # optional
    "php5-imagick",
    "php5-imap",
    "php5-xsl",
    "php5-memcache",
  ]
  package { $modules :
    ensure => latest,
    require => [ Package['php5'], Class['server'], Package['apache2'] ],
  }

  # add xdebug to bashrc
  -> exec { "add XDEBUG KEY to .bashrc":
    cwd     => "/usr/local/bin",
    command => "echo 'export XDEBUG_CONFIG=\"idekey=PHPSTORM\"' >> /home/vagrant/.bashrc",
  }

  # enable mcrypt
  exec {
    "enabling_mcrypt":
      command => 'php5enmod mcrypt && service apache2 reload',
      require => Package['php5-mcrypt'],
  }

}
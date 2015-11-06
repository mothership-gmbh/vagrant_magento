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

  # Ensure Mcrypt is enabled
  exec { "enablemcrypt":
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
    command => "php5enmod mcrypt",
    notify => Service["apache2"],
    require => Package["php5-common"],
  }
}
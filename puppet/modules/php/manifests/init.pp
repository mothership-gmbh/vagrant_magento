class php () {

exec{'sudo apt-get install php7.0':
command=>'/usr/bin/apt-get install -y php7.0'
}
$modules = [
    "php7.0-cli",
    "php7.0-common",
    "libapache2-mod-php7.0",
    "php7.0-fpm",
    "php7.0-curl",
    "php7.0-gd",
    "php7.0-mysql",
    "php7.0-bz2"
    #"php5-intl",
    #"php5-mcrypt",
    #"php5-tidy",
    #"php5-xdebug",

  # optional
    #"php5-imagick",
    #"php5-imap",
    #"php5-xsl",
    #"php5-memcache",
  ]
  package { $modules :
      ensure => latest,
      require => [ Exec['sudo apt-get install php7.0']]
    }
}
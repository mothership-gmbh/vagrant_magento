class tools::codeception {

  exec { "install codeception":
    creates => "/usr/local/bin/codecept",
    command => "curl -LsS http://codeception.com/codecept.phar -o /usr/local/bin/codecept",
    require => [ Package['php5'], Package['curl'] ],
  }
}
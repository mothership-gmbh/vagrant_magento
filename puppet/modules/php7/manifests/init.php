class php7 {

    exec{'add-apt-repository ppa:ondrej/php':
        command=>'/usr/bin/add-apt-repository ppa:ondrej/php'
    }

    exec{'apt-get update':
        command=>'/usr/bin/apt-get update',
        require => Exec['add-apt-repository ppa:ondrej/php']
    }

    exec{'sudo apt-get install php7.0':
        command=>'/usr/bin/apt-get install php7.0',
        require => Exec['apt-get update']
    }

}
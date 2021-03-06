vagrant_magento
===============

Vagrant Skript for setting up a vm with magento


#Requirements

##Vagrant

##Vagrant Host Manager
This Vagrant-File depends on the [Vagrant Host Manager](https://github.com/smdahlen/vagrant-hostmanager). This useful extension allows us, to easily manage the hosts-file on every client and host, so that you don't have to manually update the hosts-files.

Install it with the following command.

```
$ vagrant plugin install vagrant-hostmanager
```
##VirtualBox
There is also a provider for VMWare Fusion available, but this provider requires a valid license, which can be bought. For easier setup, you want to download any supported VirtualBox Version. Supported Versions are *[4.0](https://www.virtualbox.org/wiki/Download_Old_Builds_4_0)*, *[4.1](https://www.virtualbox.org/wiki/Download_Old_Builds_4_1)* and *[4.2](https://www.virtualbox.org/wiki/Download_Old_Builds_4_2)*

##VMWare
For using vmware provider use otherboxes

```
vagrant plugin install vagrant-vmware-fusion
vagrant plugin license vagrant-vmware-fusion license.lic 
```


#Quick-Start
The easiest way to setup the VM, is to just change the hostname for your project.

##VMWare
```
Start with vagrant up --provider vmware_fusion --debug
```

#Setup
##Hostname
The default hostname is *mothership-vagrant.vm*. As this Vagrantfile depends on the *Vagrant Host Manager*, the Virtual Machine will automatically be available at your host-machine.

```
Note: This might (or should) require your admin-password on your host machine, as the Host Manager wants to edit your /etc/hosts file.
```
If you prefer a more project-related hostname like *myproject.vm*, then just modify the *Vagrantfile* and reload the box. If you only want to update the hosts-file, you could instead run *vagrant hostmanager*.

```
// Vagrantfile
config.vm.hostname = "myproject.vm"
```
Run this command to reload the Vagrantfile and reboot your virtual machine.

```
vagrant reload
```

#Test
Nach der Initialisierung, kann im Webbrowser einfach mal folgende URL aufgerufen werden:

```
http://myproject.vm/info.php
```



##Shared Folders

##Konfiguration

###SSH
Username | Password | IP
------------ | ------------- 
vagrant | vagrant | 10.0.0.2

###Apache
Der Document-Root befindet sich im folgenden Pfad, wenn die Konfiguration *config.vm.hostname* den Wert *myproject.vm* hat.

```
/srv/myproject.vm
```

Der Apache-VHost befindet sich 

###MySQL


Das Admin-Passwort ist in der Standardinstallation ```root```.


Username | Password
------------ | ------------- 
admin | root
magento | magento

##Mailcatcher

Mailcatcher is a fantastic sendmail replacement while developing on the local machine. [http://mailcatcher.me/](http://mailcatcher.me/).

Mailcatcher muss folgendermaßen gestartet werden:

```
mailcatcher --ip=192.168.162.146
```



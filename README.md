vagrant_magento
===============

Vagrant Skript for setting up a vm with magento

#Einleitung
Hinweis: Dieser Branch ist experimentell. Er wird hauptsächlich benutzt, um den Einsatz von Docker-Container im Alltag zu überprüfen.
Hier sind vor Allem die Kriterien "einfach" und "muss-out-of-the-box" funktionieren wichtig.

Es wird sukzessive versucht, die Abhängigkeiten von Pakten zu lösen. Bei einigen Services wie zum Beispiel mailcatcher ist das noch nicht
optimal gelöst. Es werden also vorerst lediglich MariaDB (löst MySQL ab) und Elasticsearch als Container verwendet.

##Vagrant

##Vagrant Host Manager
This Vagrant-File depends on the [Vagrant Host Manager](https://github.com/smdahlen/vagrant-hostmanager). This useful extension allows us, to easily manage the hosts-file on every client and host, so that you don't have to manually update the hosts-files.

Install it with the following command.

```
$ vagrant plugin install vagrant-hostmanager
```
##VMWare
For using vmware provider. 

NOTE: Check for the right provider based on your host machine. 

```
vagrant plugin install vagrant-vmware-fusion
vagrant plugin license vagrant-vmware-fusion license.lic
```

##VirtualBox
There is also a provider for VMWare Fusion available, but this provider requires a valid license, which can be bought. For easier setup, you want to download any supported VirtualBox Version. Supported Versions are *[4.0](https://www.virtualbox.org/wiki/Download_Old_Builds_4_0)*, *[4.1](https://www.virtualbox.org/wiki/Download_Old_Builds_4_1)* and *[4.2](https://www.virtualbox.org/wiki/Download_Old_Builds_4_2)*

#Quick-Start
Start configuring some base parameters for the virtual machine:
```
mv config.yml.example config.yml
```
now just edit your setup in *config.yml*

##VMWare

Note: This command will only work on Mac OS X environment with VMWware Fusion installed. This will not work for linux-based environment which depends on the product ```vmware workstation```.

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

###Docker

Die Docker-Instanzen werden bei Vagrant nicht automatisch neu gestartet, zumindest nicht zuverlässig. Es gibt eine Möglichkeit, sich
alle Container anzuzeigen ```docker ps -a```. Danach lassen sich einzelne Container gezielt mit ```docker rm <id>``` entfernen. Da
sich die einzelnen Schritte automatisieren lassen, gibt es im Verzeichnis ```/usr/local/bin``` ein Script ```doker-restart.sh```. 

In den meisten Anwendungsfällen reicht dieser Befehl aus, um die Container ```elasticsearch``` und ```mariadb``` neu zu starten.

```
docker rm $(docker ps -a -q)
```


###MariaDB (MySQL)
Auf dieser virtuellen Maschine befindet sich kein klassicher MySQL-Daemon. Stattdessen wird MySQL über einen Docker-Container
ausgeliefert. Genauer gesagt über ```paintedfox/mariadb```. Dieser Container ist sehr flexibel, erfordert aber wie alle
Docker-Container ein Volume, um Daten persistent zu speichern. Damit das möglich ist, gibt es ein Verzeichnis 
```/hme/docker/mysql```, dass bei jedem Start gemountet werden muss. Hierzu kann folgender Befehl benutzt werden:

```
docker run -d --name=mariadb -p 127.0.0.1:3306:3306 -v /opt/mariadb/data:/data -e USER="super" -e PASS="super123" paintedfox/mariadb
```

Wenn die VM ausgeschaltet wurde, lässt sich diese wieder durch den Befehl starten.


###Elasticsearch

Elasticsearch wird ebenfalls über einen Docker-Container ausgeliefert. Eigentlich funktioniert das problemlos out-of-the-box. 
Interessant ist lediglich die Datei ```home/docker/elasticsearch/data/elasticsearch.yml```. Es handelt sich dabei 1:1 um eine
gültige Elasticsearch Konfiguration. Die einzige Modifikationen sind momentan die Pfade für die Daten und Logs für das Mapping 
und die Aktivierung des Scriptings.

```
docker run -d -p 9200:9200 -p 9300:9300 -v /home/docker/elasticsearch:/data elasticsearch /usr/share/elasticsearch/bin/elasticsearch -Des.config=/data/elasticsearch.yml -Des.config=/data/elasticsearch.yml
```

###Selenium

Selenium wird auf dieser Maschine als HUB ausgeführt. Ein HUB ist ein zentraler Server, der alle Requests entgegennimmt und diese auf beliebige Maschinen verteilt. An diesem HUB können sich nun einzelne Clients registrieren, auf denen zb. Firefox oder Chrome laufen. Dies wird in der Regel gemacht, um bei einem dedizierten Server möglichst viele Tests gleichmäßig auf beliebige Maschinen zu verteilen.

Unser Use-Case schaut nun so aus, dass auf der virtuellen Maschine ein Hub läuft. Hierzu gibt es bereits ein Skript ```selenium-start.sh```. Wichtig nach dem Start ist die Ausgabe, die eine Information enthält wie zum Beispiel: ```http://123.456.789.123:4444/grid/register ```. Dabei handelt es sich um die IP und Port des HUB, an denen sich die Clients registrieren können.

Im Folgenden muss Selenium auf dem Client runtergeladen werden (http://www.seleniumhq.org/download/) , falls noch nicht geschehen. Dann einfach Selenium auf der lokalen Kiste wie folgt starten (Die variablen Teile entsprechend anpassen):

```
wget http://goo.gl/PJUZfa /<woduwillst>/<selenium_server_name>.jar
java -jar <selenium_server_name>.jar -role node -hub http://<deinevm>:<deinport>/grid/register
```

Wenn du nun auf ```http://<deinevm>:<deinport>/grid/console``` gehst, sollte es verschiedene Einträge geben, die zeigen, dass du deinen Client erfolgreich verbunden hast.

#Node


```
# https://registry.hub.docker.com/u/dockerfile/nodejs/ (builds on ubuntu:14.04)
FROM node

MAINTAINER My Name, me@email.com

ENV HOME /home/web
WORKDIR /home/web/site

RUN useradd web -d /home/web -s /bin/bash -m

RUN npm install -g grunt-cli
RUN npm install -g bower

RUN chown -R web:web /home/web
USER web


ENV NODE_ENV development

# Port 9000 for server
# Port 35729 for livereload
EXPOSE 8888
CMD grunt

docker run -it --rm --name my-running-script -v "$PWD":/tmp/app -w /tmp/app my-npm-app npm install
docker run -it --rm --name my-running-script -v "$PWD":/tmp/app -w /tmp/app my-npm-app grunt debug
```


##Mailcatcher

Mailcatcher is a fantastic sendmail replacement while developing on the local machine. [http://mailcatcher.me/](http://mailcatcher.me/).

Mailcatcher muss folgendermaßen gestartet werden:

```
mailcatcher --ip=192.168.162.146
```


###Docker Script

```
#!/bin/bash
docker rm $(docker ps -a -q)
docker run -d --name=mariadb -p 127.0.0.1:3306:3306 -v /opt/mariadb/data:/data -e USER="super" -e PASS="super123" paintedfox/mariadb
docker run -d -p 9200:9200 -p 9300:9300 -v /home/docker/elasticsearch:/data elasticsearch /usr/share/elasticsearch/bin/elasticsearch -Des.config=/data/elasticsearch.yml -Des.config=/data/elasticsearch.yml
```

#Tipps und Befehle

##local.xml und .htaccess relativ zum Projektordner anlegen
Wenn man öfter neue Magento-Projekte initialisiert, ist es ziemlich nervig, immer diese Dateien neu anzulegen. In dem Fall gibt es den Befehl ```init_magento.sh``` der überall ausgeführt werden kann. Dieser legt relativ zum aktuellen Verzeichnis die Dateien ```.htaccess``` und ```app/etc/local.xml``` an.

Beispiel:

```
cd /srv/project.vm/www
init_magento.sh
```


##SSH Key - Private Repositories

Falls du ein privates Repository hast, solltest du folgende Schritte ausführen:

1. Auf dem Hostsystem deinen Private-Key auf dem Server übertragen

   ```
   scp ~/.ssh/id_* vagrant@<hostname>:/home/vagrant
   ```
2. Alternativ einfach einen Alias anlegen, wenn man diesen Befehl öfter benötigt. In dem Beispiel hat die Vagrant-Maschineimmer die IP ```10.0.1.69```
 
   ```
   alias copy_key='scp ~/.ssh/id_rsa vagrant@10.0.1.69:/home/vagrant/.ssh/id_rsa'
   ```

2. Das nervige Passphrase beenden

   Oftmals wird man wegen dem SSH-Manager nach dem Passphrase gefragt. Einfach auf der Konsole folgende Befehle eingeben. Hilft sofort.

    ```
    eval $(ssh-agent)
    ssh-add
    ```




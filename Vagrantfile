# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

config_file = './' + 'config.yml'
if !File.exist?(config_file)
  puts 'Please copy config.yml.example to ' + config_file
    + ' and modify configuration variables as required for your development environment.'
end

# Based on https://stefanwrobel.com/how-to-make-vagrant-performance-not-suck
# Give VM 1/4 system memory & access to all cpu cores on the host
host = RbConfig::CONFIG['host_os']

 # Give VM 1/4 system memory & access to all cpu cores on the host
 if host =~ /darwin/
   cpu_default = `sysctl -n hw.ncpu`.to_i
   # sysctl returns Bytes and we need to convert to MB
   mem_default = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
 elsif host =~ /linux/
   cpu_default = `nproc`.to_i
   # meminfo shows KB and we need to convert to MB
   mem_default = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
 else # sorry Windows folks, I can't help you
   cpu_default = 2
   mem_default = 2048
 end

CONFIG = YAML.load_file(config_file)

cpu_core = CONFIG['cpu_core'] || cpu_default
ram      = CONFIG['ram']      || mem_default
ip       = CONFIG['ip']       || "10.0.1.69"
path     = CONFIG['path']     || Dir.pwd
#vagrant_path = CONFIG['vagrant_path']   ||  "/srv/" + config.vm.hostname + "/shared"

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    if Vagrant.has_plugin?("vagrant-cachier")
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
        config.cache.scope = :box
    end

    # https://github.com/phusion/open-vagrant-boxes
    config.vm.box     = "phusion-open-ubuntu-14.04-amd64"
    config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vmwarefusion.box"

    #config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.hostname = CONFIG['hostname']

    config.hostmanager.enabled           = true
    config.hostmanager.manage_host       = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline   = true

    # This is only needed for the communication between host- and guest-system
    config.vm.network :private_network, ip: ip

    host = RbConfig::CONFIG['host_os']


    # The folder are synced via nfs. It is recommended to not use the shared folder
    # as the apache root directory. Just use it for file sharing. You do not want to
    # mix .modman symlinks, cache files etc with your repository, even with .gitignore
    #config.vm.synced_folder path, vagrant_path, type: "nfs", create: true

    config.vm.provider :vmware_workstation do |v|
        #v.gui = true
        v.vmx["memsize"]  = ram
        v.vmx["numvcpus"] = cpu_core
        v.name            = config.vm.hostname
    end

    # "Provision" with hostmanager
    config.vm.provision :hostmanager

    # Puppet!
    config.vm.provision :puppet do |puppet|

        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "init.pp"
        puppet.module_path    = "puppet/modules"
        puppet.options        = "--verbose --debug"

        # Factors
        puppet.facter = {
            "vagrant" => "1",

            "db_root_password" => "root",
            "db_user"          => "root",
            "db_password"      => "root",
            "db_name"          => "dev",
            "db_name_tests"    => "dev",

            # Apache
            "hostname"         => config.vm.hostname,
            "document_root"    => "/srv/"
        }
    end

    config.vm.provision "docker" do |d|
      d.pull_images "elasticsearch"
      d.pull_images "paintedfox/mariadb"
    end
end
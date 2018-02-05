# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'

Vagrant.require_version ">= 1.6.0"

# Make sure the vagrant-hostmanager plugin is installed
required_plugins = %w(vagrant-hostmanager)

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

CONFIG = File.join(File.dirname(__FILE__), "config.rb")

# Defaults for config options defined in CONFIG
$num_instances = 1
$instance_name_prefix = "centos"
$enable_serial_logging = false
$share_home = false
$vm_gui = false
$vm_memory = 1024
$vm_cpus = 1
$forwarded_ports = {}
$password_authentication = false

$master_instances = []
$master_name_prefix = "master"

# Attempt to apply the deprecated environment variable NUM_INSTANCES to
# $num_instances while allowing config.rb to override it
if ENV["NUM_INSTANCES"].to_i > 0 && ENV["NUM_INSTANCES"]
  $num_instances = ENV["NUM_INSTANCES"].to_i
end

# Use old vb_xxx config variables when set
def vm_gui
  $vb_gui.nil? ? $vm_gui : $vb_gui
end

def vm_memory
  $vb_memory.nil? ? $vm_memory : $vb_memory
end

def vm_cpus
  $vb_cpus.nil? ? $vm_cpus : $vb_cpus
end

Vagrant.configure("2") do |config|
  # always use Vagrants insecure key
  config.ssh.insert_key = false
  
  config.vm.box = "phensley/centos-7-java"
  config.vm.box_version = "0.0.1"

  # enable hostmanager
  config.hostmanager.enabled = true

  # configure the host's /etc/hosts
  config.hostmanager.manage_host = true

  # PasswordAuthentication yes
  if $password_authentication
    config.vm.provision "shell", inline: <<-EOC
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
      systemctl restart sshd;
    EOC
  end

  master_count = 0
  slave_count = 0

  (1..$num_instances).each do |i|
    if $master_instances.include?(i)
      if $master_instances.length == 1
        vm_name = $master_name_prefix
      else
        vm_name = "%s%02d" % [$master_name_prefix, master_count += 1]
      end
    else
      if $num_instances - $master_instances.length == 1
	    vm_name = $instance_name_prefix
      else
        vm_name = "%s%02d" % [$instance_name_prefix, slave_count += 1]
      end
    end
    
    config.vm.define vm_name do |config|
      vm_hostname = $domain_name ? "#{vm_name}.#{$domain_name}" : vm_name
	  
	  # Setup Hostname
      config.vm.hostname = vm_name
	  config.hostmanager.aliases = %w(vm_hostname)
	  
	  config.vm.provision :shell, inline: <<-EOC
	    systemctl start ntpd
	    timedatectl set-timezone Asia/Seoul
	    systemctl disable firewalld
	    setenforce 0
	    systemctl disable packagekit
	    bash -c 'echo -e "umask 0022" >> /etc/profile'
	  EOC

      if $enable_serial_logging
        logdir = File.join(File.dirname(__FILE__), "log")
        FileUtils.mkdir_p(logdir)

        serialFile = File.join(logdir, "%s-serial.txt" % vm_name)
        FileUtils.touch(serialFile)

        config.vm.provider :virtualbox do |vb, override|
          vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
          vb.customize ["modifyvm", :id, "--uartmode1", serialFile]
        end
      end

      # foward Docker registry port to host for node 01
      if i == 1
        config.vm.network :forwarded_port, guest: 5000, host: 5000
      end

      config.vm.provider :virtualbox do |vb|
        vb.gui = vm_gui
        vb.memory = vm_memory
        vb.cpus = vm_cpus
      end

      ip = "172.17.11.#{i+100}"
      config.vm.network :private_network, ip: ip
    end
  end
end

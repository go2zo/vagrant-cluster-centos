# Size of the Linux cluster created by Vagrant
$num_instances=3

# Change basename of the VM
# The default value is "centos", which results in VMs named starting with
# "centos-01" through to "centos-${num_instances}".
$instance_name_prefix = "slave"

# Customize VMs
#$vm_gui = false
$vm_memory = 4096
$vm_cpus = 2
#$vb_cpuexecutioncap = 100

# Master Clusters
$master_instances = [1]

# Change prefix of the Master VM
$master_name_prefix = "master"

$domain_name = "apexsw.com"
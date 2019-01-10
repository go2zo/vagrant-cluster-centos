# Size of the Linux cluster created by Vagrant
#$num_instances=1
$num_instances=2

# Change basename of the VM
# The default value is "centos", which results in VMs named starting with
# "centos-01" through to "centos-${num_instances}".
#$instance_name_prefix = "centos"

# Customize VMs
#$vm_gui = false
#$vm_memory = 1024
$vm_memory = 2048
#$vm_cpus = 1
$vm_cpus = 2
#$vb_cpuexecutioncap = 100
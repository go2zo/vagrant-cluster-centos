# Size of the Linux cluster created by Vagrant
#$num_instances=1
$num_instances=3

# Change basename of the VM
# The default value is "centos", which results in VMs named starting with
# "centos-01" through to "centos-${num_instances}".
#$instance_name_prefix = "centos"

# Customize VMs
#$vm_gui = false
#$vm_memory = 1024
#$vm_cpus = 1
#$vb_cpuexecutioncap = 100

$instances_config="instances.yml"
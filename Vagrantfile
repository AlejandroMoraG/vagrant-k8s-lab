## Number of worker nodes
WorkerNodes = 2

Vagrant.configure(2) do |config|

    # Kubernetes Master Node
    config.vm.define "controlplane" do |controlplane|
        controlplane.vm.box = "rockylinux/9"
        controlplane.vm.hostname = "controlplane.k8s.lab"
        controlplane.vm.network "private_network", ip: "10.0.0.10"
            controlplane.vm.provider "virtualbox" do |v|
                v.name = "controlplane"
                v.memory = 4096
                v.cpus = 2
            end
        (1..WorkerNodes).each do |i|
            controlplane.vm.provision "shell", inline: "echo 10.0.0.1#{i} node#{i}.k8s.lab >> /etc/hosts"
        end
        controlplane.vm.provision "shell", path: "scripts/common.sh"
        controlplane.vm.provision "shell", path: "scripts/master.sh"
    end

    # Kubernetes Worker Nodes
    (1..WorkerNodes).each do |i|
        config.vm.define "node#{i}" do |node|
            node.vm.box = "rockylinux/9"
            node.vm.hostname = "node#{i}.k8s.lab"
            node.vm.network "private_network", ip: "10.0.0.1#{i}"
            node.vm.provider "virtualbox" do |v|
                v.name = "node#{i}"
                v.memory = 4096
                v.cpus = 1
            end
            (1..WorkerNodes).each do |i|
                node.vm.provision "shell", inline: "echo 10.0.0.1#{i} node#{i}.k8s.lab >> /etc/hosts"
            end
            node.vm.provision "shell", path: "scripts/common.sh"
            node.vm.provision "shell", path: "scripts/worker.sh"
        end
    end
end
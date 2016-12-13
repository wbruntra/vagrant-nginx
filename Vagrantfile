Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", host: 8080, guest: 80
  config.vm.synced_folder "site", "/home/vagrant/site"
  config.vm.synced_folder "code", "/home/vagrant/code"
  config.vm.provision :shell, path: "bootstrap-py3.sh"
  config.vm.provision :shell, path: "associate.sh",
   run: "always"
end

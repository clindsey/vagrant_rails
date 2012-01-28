Vagrant::Config.run do |config|
  config.vm.box = "base"
  config.vm.forward_port(80, 4568)
  config.vm.provision :shell, :path => "vagrant_setup.sh"
  config.ssh.forward_agent = true
end

Vagrant.configure("2") do |config|

  # Load config JSON.
  config_json = JSON.parse(File.read("config.json"))

  # Prepare base box.
  # config.vm.box = "rafacas/oel63-plain"
  config.vm.box = config_json["dc"]["distribute"]

  # Configure networking.
  config.vm.network :private_network, ip: config_json["dc"]["ip"]
  
  # Configure forwarded ports.
  config.vm.network "forwarded_port", guest: 35729, host: 35729, protocol: "tcp", auto_correct: true
  
  # User defined forwarded ports.
  config_json["dc"]["forwarded_ports"].each do |port|
    config.vm.network "forwarded_port", guest: port["guest_port"],
      host: port["host_port"], protocol: port["protocol"], auto_correct: true
  end

  # Customize provider.
  config.vm.provider :virtualbox do |vb|
    # RAM.
    vb.customize ["modifyvm", :id, "--memory", config_json["dc"]["memory"]]

    # Synced Folders.
    config_json["dc"]["synced_folders"].each do |folder|
      case folder["type"]
      when "nfs"
        config.vm.synced_folder folder["host_path"], folder["guest_path"], type: "nfs"
        # This uses uid and gid of the user that started vagrant.
        config.nfs.map_uid = Process.uid
        config.nfs.map_gid = Process.gid
      else
        config.vm.synced_folder folder["host_path"], folder["guest_path"]
      end
    end
  end

  # Run initial shell script.
  config.vm.provision :shell, :path => "cookbooks/shell/initial.sh", :args => config_json["dc"]["chef"]

  # Customize provisioner.
  config.vm.provision "chef_solo" do |chef|
    chef.json = config_json
    chef.cookbooks_path = ["cookbooks/chef", "cookbooks/custom"]
    chef.data_bags_path = "cookbooks/data_bags"
    chef.roles_path = "cookbooks/roles"
    chef.add_role "dc"
  end
  
  # Run final shell script.
  config.vm.provision :shell, :path => "cookbooks/shell/final.sh", :args => config_json["dc"]["ip"]
end
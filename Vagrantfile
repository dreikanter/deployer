Vagrant.require_version '>= 1.5'

REQUIRED_PLUGINS = [
  ['vagrant-bindfs', '0.3.2'],
  ['vagrant-vbguest', '0.12.0']
].freeze

def require_plugins!(plugins)
  pugins = plugins.reject { |p| Vagrant.has_plugin?(p.first) }
  pugins.each do |plugin, version|
    next if Vagrant.has_plugin?(plugin)
    system(install_plugin_command(plugin, version)) || exit!
  end
  exit system('vagrant', *ARGV) unless pugins.empty?
end

def install_plugin_command(plugin, version = nil)
  [].tap do |a|
    a << 'vagrant plugin install'
    a << plugin
    a << "--plugin-version #{version}" if version
  end.join(' ')
end

require_plugins!(REQUIRED_PLUGINS)

Vagrant.configure('2') do |config|
  config.vm.provider :virtualbox do |vb, _override|
    vb.memory = 1024
    vb.cpus = 1
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
  end

  config.vm.define 'app' do |machine|
    machine.vm.hostname = 'localhost'
    machine.vm.network 'forwarded_port', guest: 3000, host: 3001, auto_correct: true
    machine.vm.box = 'ubuntu/trusty64'
    machine.vm.network 'private_network', ip: '192.168.99.99'
    config.vm.synced_folder '.', '/app-nfs', type: :nfs
    config.bindfs.bind_folder '/app-nfs', '/app'

    machine.vm.provision :ansible_local do |ansible|
      ansible.verbose        = true
      ansible.install        = true
      ansible.version        = '2.1'
      ansible.provisioning_path = '/app/ansible'
      ansible.limit          = 'all'
      ansible.playbook       = 'provision_development.yml'
      ansible.inventory_path = 'inventory/development'
    end
  end

  config.ssh.forward_agent = true
end

require_relative '../spec_helper.rb'

describe 'nw-log-collector::rabbitmq' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.automatic['packages'] = {}
      node.normal['nw-log-collector']['rabbitmq']['vhosts'] = %w(quux)
      node.normal['nw-log-collector']['rabbitmq']['users'] = [{
        'name' => 'foobar',
        'password' => 'weaksauce',
        'administrator' => true,
        'vhosts' => [{
          'name' => 'quux',
          'permissions' => '.* .* .*'
        }]
      }]
      node.normal['nw-log-collector']['rabbitmq']['policies'] = [{
        'name' => 'expiry',
        'pattern' => '.*',
        'params' => {
          'expires' => '86400'
        },
        'vhost' => '/',
        'apply_to' => 'queues'
      }]
    end.converge(described_recipe)
  end

  context 'When attempting to deploy the RabbitMQ plugin with packages present' do
    plugin_dir = '/usr/lib/rabbitmq/lib/rabbitmq_server-4.5.6/plugins'
    plugin_file = ::File.join(plugin_dir, 'nw_admin.ez')
    orig = 'file:///opt/netwitness/nw_admin-1.2.3.ez'

    it 'skips reloading the Ohai package index' do
      chef_run.node.automatic['packages']['nwlogcollector'] = {
        'version' => '1.2.3'
      }
      chef_run.node.automatic['packages']['rabbitmq-server'] = {
        'version' => '4.5.6'
      }
      chef_run.converge(described_recipe)
      expect(chef_run).not_to reload_ohai('reload package list')
    end

    it 'creates the plugin_dir' do
      chef_run.node.automatic['packages']['nwlogcollector'] = {
        'version' => '1.2.3'
      }
      chef_run.node.automatic['packages']['rabbitmq-server'] = {
        'version' => '4.5.6'
      }
      chef_run.converge(described_recipe)
      expect(chef_run).to create_directory(plugin_dir).with(recursive: true)
      expect(chef_run).not_to delete_directory(plugin_dir)
    end

    it 'copies the plugin file to the target location' do
      chef_run.node.automatic['packages']['nwlogcollector'] = {
        'version' => '1.2.3'
      }
      chef_run.node.automatic['packages']['rabbitmq-server'] = {
        'version' => '4.5.6'
      }
      chef_run.converge(described_recipe)
      expect(chef_run).to create_remote_file(plugin_file).with(
        source: orig,
        owner: 'root',
        group: 'root',
        mode: 0o444
      )
      stub_plugin = chef_run.nw_rabbitmq_plugin('nw_admin')
      expect(stub_plugin).to do_nothing
    end
  end

  context 'When attempting to deploy the RabbitMQ plugin with packages absent' do
    plugin_dir = '/usr/lib/rabbitmq/lib/rabbitmq_server-/plugins'
    plugin_file = ::File.join(plugin_dir, 'nw_admin.ez')
    orig = 'file:///opt/netwitness/nw_admin-.ez'

    it 'reloads the Ohai package index' do
      expect(chef_run).to reload_ohai('reload package list')
    end

    it 'does not create the plugin_dir' do
      expect(chef_run).not_to create_directory(plugin_dir).with(recursive: true)
    end

    it 'does not copy the plugin file to the target location' do
      expect(chef_run).not_to create_remote_file(plugin_file).with(
        source: orig,
        owner: 'root',
        group: 'root',
        mode: 0o444
      )
      stub_plugin = chef_run.nw_rabbitmq_plugin('nw_admin')
      expect(stub_plugin).to do_nothing
    end
  end

  context 'When setting the RabbitMQ policies' do
    it 'sets the expiry policy' do
      expect(chef_run).to set_nw_rabbitmq_policy('expiry')
      expect(chef_run).not_to clear_nw_rabbitmq_policy('expiry')
      expect(chef_run).not_to list_nw_rabbitmq_policy
    end
  end

  context 'When creating the RabbitMQ users and vhosts' do
    it 'adds the RabbitMQ vhost' do
      expect(chef_run).to add_nw_rabbitmq_vhost('quux')
    end

    it 'adds the RabbitMQ user' do
      expect(chef_run).to add_nw_rabbitmq_user('add foobar').with(
        user: 'foobar',
        password: 'weaksauce'
      )
      expect(chef_run).not_to clear_password_nw_rabbitmq_user(
        'clear_password foobar'
      )
    end

    it 'makes the RabbitMQ user administrator' do
      expect(chef_run).to set_tags_nw_rabbitmq_user('set_tags foobar').with(
        user: 'foobar',
        tag: 'administrator'
      )
    end

    it 'grants the RabbitMQ user permissions to the vhost' do
      title = 'set_permissions foobar on quux'
      expect(chef_run).to set_permissions_nw_rabbitmq_user(title).with(
        user: 'foobar',
        vhost: 'quux',
        permissions: '.* .* .*'
      )
    end
  end
end

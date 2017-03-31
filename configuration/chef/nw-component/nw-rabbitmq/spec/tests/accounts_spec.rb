require_relative '../spec_helper.rb'

describe 'nw-rabbitmq::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-rabbitmq']['accounts'] = [{
        'name' => 'nw-rabbitmq',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-rabbitmq').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-rabbitmq')
      expect(chef_run).not_to modify_group('nw-rabbitmq')
      expect(chef_run).not_to remove_group('nw-rabbitmq')

      expect(chef_run).to create_user('nw-rabbitmq').with(uid: 501)
      expect(chef_run).not_to manage_user('nw-rabbitmq')
      expect(chef_run).not_to modify_user('nw-rabbitmq')
      expect(chef_run).not_to remove_user('nw-rabbitmq')
      expect(chef_run).not_to lock_user('nw-rabbitmq')
      expect(chef_run).not_to unlock_user('nw-rabbitmq')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-rabbitmq']['accounts'] = [{
        'name' => 'nw-rabbitmq',
        'uid' => 501,
        'home' => '/home/nw-rabbitmq'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-rabbitmq').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-rabbitmq')
      expect(chef_run).not_to modify_group('nw-rabbitmq')
      expect(chef_run).not_to remove_group('nw-rabbitmq')

      expect(chef_run).to create_user('nw-rabbitmq').with(
        uid: 501, home: '/home/nw-rabbitmq'
      )
      expect(chef_run).not_to manage_user('nw-rabbitmq')
      expect(chef_run).not_to modify_user('nw-rabbitmq')
      expect(chef_run).not_to remove_user('nw-rabbitmq')
      expect(chef_run).not_to lock_user('nw-rabbitmq')
      expect(chef_run).not_to unlock_user('nw-rabbitmq')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-rabbitmq']['accounts'] = [{
        'name' => 'nw-rabbitmq',
        'uid' => 501,
        'home' => '/home/nw-rabbitmq',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-rabbitmq').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-rabbitmq')
      expect(chef_run).not_to modify_group('nw-rabbitmq')
      expect(chef_run).not_to remove_group('nw-rabbitmq')

      expect(chef_run).to create_user('nw-rabbitmq').with(
        uid: 501, home: '/home/nw-rabbitmq', manage_home: true
      )
      expect(chef_run).not_to manage_user('nw-rabbitmq')
      expect(chef_run).not_to modify_user('nw-rabbitmq')
      expect(chef_run).not_to remove_user('nw-rabbitmq')
      expect(chef_run).not_to lock_user('nw-rabbitmq')
      expect(chef_run).not_to unlock_user('nw-rabbitmq')
    end
  end
end

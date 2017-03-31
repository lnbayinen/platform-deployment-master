require_relative '../spec_helper.rb'

describe 'salt-master::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['salt-master']['accounts'] = [{
        'name' => 'salt-master',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('salt-master').with(gid: 501)
      expect(chef_run).not_to manage_group('salt-master')
      expect(chef_run).not_to modify_group('salt-master')
      expect(chef_run).not_to remove_group('salt-master')

      expect(chef_run).to create_user('salt-master').with(uid: 501)
      expect(chef_run).not_to manage_user('salt-master')
      expect(chef_run).not_to modify_user('salt-master')
      expect(chef_run).not_to remove_user('salt-master')
      expect(chef_run).not_to lock_user('salt-master')
      expect(chef_run).not_to unlock_user('salt-master')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['salt-master']['accounts'] = [{
        'name' => 'salt-master',
        'uid' => 501,
        'home' => '/home/salt-master'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('salt-master').with(gid: 501)
      expect(chef_run).not_to manage_group('salt-master')
      expect(chef_run).not_to modify_group('salt-master')
      expect(chef_run).not_to remove_group('salt-master')

      expect(chef_run).to create_user('salt-master').with(
        uid: 501, home: '/home/salt-master'
      )
      expect(chef_run).not_to manage_user('salt-master')
      expect(chef_run).not_to modify_user('salt-master')
      expect(chef_run).not_to remove_user('salt-master')
      expect(chef_run).not_to lock_user('salt-master')
      expect(chef_run).not_to unlock_user('salt-master')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['salt-master']['accounts'] = [{
        'name' => 'salt-master',
        'uid' => 501,
        'home' => '/home/salt-master',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('salt-master').with(gid: 501)
      expect(chef_run).not_to manage_group('salt-master')
      expect(chef_run).not_to modify_group('salt-master')
      expect(chef_run).not_to remove_group('salt-master')

      expect(chef_run).to create_user('salt-master').with(
        uid: 501, home: '/home/salt-master', manage_home: true
      )
      expect(chef_run).not_to manage_user('salt-master')
      expect(chef_run).not_to modify_user('salt-master')
      expect(chef_run).not_to remove_user('salt-master')
      expect(chef_run).not_to lock_user('salt-master')
      expect(chef_run).not_to unlock_user('salt-master')
    end
  end
end

require_relative '../spec_helper.rb'

describe 'salt-api::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['salt-api']['accounts'] = [{
        'name' => 'salt-api',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('salt-api').with(gid: 501)
      expect(chef_run).not_to manage_group('salt-api')
      expect(chef_run).not_to modify_group('salt-api')
      expect(chef_run).not_to remove_group('salt-api')

      expect(chef_run).to create_user('salt-api').with(uid: 501)
      expect(chef_run).not_to manage_user('salt-api')
      expect(chef_run).not_to modify_user('salt-api')
      expect(chef_run).not_to remove_user('salt-api')
      expect(chef_run).not_to lock_user('salt-api')
      expect(chef_run).not_to unlock_user('salt-api')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['salt-api']['accounts'] = [{
        'name' => 'salt-api',
        'uid' => 501,
        'home' => '/home/salt-api'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('salt-api').with(gid: 501)
      expect(chef_run).not_to manage_group('salt-api')
      expect(chef_run).not_to modify_group('salt-api')
      expect(chef_run).not_to remove_group('salt-api')

      expect(chef_run).to create_user('salt-api').with(
        uid: 501, home: '/home/salt-api'
      )
      expect(chef_run).not_to manage_user('salt-api')
      expect(chef_run).not_to modify_user('salt-api')
      expect(chef_run).not_to remove_user('salt-api')
      expect(chef_run).not_to lock_user('salt-api')
      expect(chef_run).not_to unlock_user('salt-api')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['salt-api']['accounts'] = [{
        'name' => 'salt-api',
        'uid' => 501,
        'home' => '/home/salt-api',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('salt-api').with(gid: 501)
      expect(chef_run).not_to manage_group('salt-api')
      expect(chef_run).not_to modify_group('salt-api')
      expect(chef_run).not_to remove_group('salt-api')

      expect(chef_run).to create_user('salt-api').with(
        uid: 501, home: '/home/salt-api', manage_home: true
      )
      expect(chef_run).not_to manage_user('salt-api')
      expect(chef_run).not_to modify_user('salt-api')
      expect(chef_run).not_to remove_user('salt-api')
      expect(chef_run).not_to lock_user('salt-api')
      expect(chef_run).not_to unlock_user('salt-api')
    end
  end
end

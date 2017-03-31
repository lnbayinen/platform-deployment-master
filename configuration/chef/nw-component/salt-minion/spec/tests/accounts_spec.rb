require_relative '../spec_helper.rb'

describe 'salt-minion::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['salt-minion']['accounts'] = [{
        'name' => 'salt-minion',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('salt-minion').with(gid: 501)
      expect(chef_run).not_to manage_group('salt-minion')
      expect(chef_run).not_to modify_group('salt-minion')
      expect(chef_run).not_to remove_group('salt-minion')

      expect(chef_run).to create_user('salt-minion').with(uid: 501)
      expect(chef_run).not_to manage_user('salt-minion')
      expect(chef_run).not_to modify_user('salt-minion')
      expect(chef_run).not_to remove_user('salt-minion')
      expect(chef_run).not_to lock_user('salt-minion')
      expect(chef_run).not_to unlock_user('salt-minion')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['salt-minion']['accounts'] = [{
        'name' => 'salt-minion',
        'uid' => 501,
        'home' => '/home/salt-minion'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('salt-minion').with(gid: 501)
      expect(chef_run).not_to manage_group('salt-minion')
      expect(chef_run).not_to modify_group('salt-minion')
      expect(chef_run).not_to remove_group('salt-minion')

      expect(chef_run).to create_user('salt-minion').with(
        uid: 501, home: '/home/salt-minion'
      )
      expect(chef_run).not_to manage_user('salt-minion')
      expect(chef_run).not_to modify_user('salt-minion')
      expect(chef_run).not_to remove_user('salt-minion')
      expect(chef_run).not_to lock_user('salt-minion')
      expect(chef_run).not_to unlock_user('salt-minion')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['salt-minion']['accounts'] = [{
        'name' => 'salt-minion',
        'uid' => 501,
        'home' => '/home/salt-minion',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('salt-minion').with(gid: 501)
      expect(chef_run).not_to manage_group('salt-minion')
      expect(chef_run).not_to modify_group('salt-minion')
      expect(chef_run).not_to remove_group('salt-minion')

      expect(chef_run).to create_user('salt-minion').with(
        uid: 501, home: '/home/salt-minion', manage_home: true
      )
      expect(chef_run).not_to manage_user('salt-minion')
      expect(chef_run).not_to modify_user('salt-minion')
      expect(chef_run).not_to remove_user('salt-minion')
      expect(chef_run).not_to lock_user('salt-minion')
      expect(chef_run).not_to unlock_user('salt-minion')
    end
  end
end

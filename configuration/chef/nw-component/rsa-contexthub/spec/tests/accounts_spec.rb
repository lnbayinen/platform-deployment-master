require_relative '../spec_helper.rb'

describe 'rsa-contexthub::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['rsa-contexthub']['accounts'] = [{
        'name' => 'rsa-contexthub',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('rsa-contexthub').with(gid: 501)
      expect(chef_run).not_to manage_group('rsa-contexthub')
      expect(chef_run).not_to modify_group('rsa-contexthub')
      expect(chef_run).not_to remove_group('rsa-contexthub')

      expect(chef_run).to create_user('rsa-contexthub').with(uid: 501)
      expect(chef_run).not_to manage_user('rsa-contexthub')
      expect(chef_run).not_to modify_user('rsa-contexthub')
      expect(chef_run).not_to remove_user('rsa-contexthub')
      expect(chef_run).not_to lock_user('rsa-contexthub')
      expect(chef_run).not_to unlock_user('rsa-contexthub')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['rsa-contexthub']['accounts'] = [{
        'name' => 'rsa-contexthub',
        'uid' => 501,
        'home' => '/home/rsa-contexthub'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('rsa-contexthub').with(gid: 501)
      expect(chef_run).not_to manage_group('rsa-contexthub')
      expect(chef_run).not_to modify_group('rsa-contexthub')
      expect(chef_run).not_to remove_group('rsa-contexthub')

      expect(chef_run).to create_user('rsa-contexthub').with(
        uid: 501, home: '/home/rsa-contexthub'
      )
      expect(chef_run).not_to manage_user('rsa-contexthub')
      expect(chef_run).not_to modify_user('rsa-contexthub')
      expect(chef_run).not_to remove_user('rsa-contexthub')
      expect(chef_run).not_to lock_user('rsa-contexthub')
      expect(chef_run).not_to unlock_user('rsa-contexthub')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['rsa-contexthub']['accounts'] = [{
        'name' => 'rsa-contexthub',
        'uid' => 501,
        'home' => '/home/rsa-contexthub',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('rsa-contexthub').with(gid: 501)
      expect(chef_run).not_to manage_group('rsa-contexthub')
      expect(chef_run).not_to modify_group('rsa-contexthub')
      expect(chef_run).not_to remove_group('rsa-contexthub')

      expect(chef_run).to create_user('rsa-contexthub').with(
        uid: 501, home: '/home/rsa-contexthub', manage_home: true
      )
      expect(chef_run).not_to manage_user('rsa-contexthub')
      expect(chef_run).not_to modify_user('rsa-contexthub')
      expect(chef_run).not_to remove_user('rsa-contexthub')
      expect(chef_run).not_to lock_user('rsa-contexthub')
      expect(chef_run).not_to unlock_user('rsa-contexthub')
    end
  end
end

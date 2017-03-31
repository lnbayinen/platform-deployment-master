require_relative '../spec_helper.rb'

describe 'nw-re-server::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-re-server']['accounts'] = [{
        'name' => 'nw-re-server',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-re-server').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-re-server')
      expect(chef_run).not_to modify_group('nw-re-server')
      expect(chef_run).not_to remove_group('nw-re-server')

      expect(chef_run).to create_user('nw-re-server').with(uid: 501)
      expect(chef_run).not_to manage_user('nw-re-server')
      expect(chef_run).not_to modify_user('nw-re-server')
      expect(chef_run).not_to remove_user('nw-re-server')
      expect(chef_run).not_to lock_user('nw-re-server')
      expect(chef_run).not_to unlock_user('nw-re-server')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-re-server']['accounts'] = [{
        'name' => 'nw-re-server',
        'uid' => 501,
        'home' => '/home/nw-re-server'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-re-server').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-re-server')
      expect(chef_run).not_to modify_group('nw-re-server')
      expect(chef_run).not_to remove_group('nw-re-server')

      expect(chef_run).to create_user('nw-re-server').with(
        uid: 501, home: '/home/nw-re-server'
      )
      expect(chef_run).not_to manage_user('nw-re-server')
      expect(chef_run).not_to modify_user('nw-re-server')
      expect(chef_run).not_to remove_user('nw-re-server')
      expect(chef_run).not_to lock_user('nw-re-server')
      expect(chef_run).not_to unlock_user('nw-re-server')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-re-server']['accounts'] = [{
        'name' => 'nw-re-server',
        'uid' => 501,
        'home' => '/home/nw-re-server',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-re-server').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-re-server')
      expect(chef_run).not_to modify_group('nw-re-server')
      expect(chef_run).not_to remove_group('nw-re-server')

      expect(chef_run).to create_user('nw-re-server').with(
        uid: 501, home: '/home/nw-re-server', manage_home: true
      )
      expect(chef_run).not_to manage_user('nw-re-server')
      expect(chef_run).not_to modify_user('nw-re-server')
      expect(chef_run).not_to remove_user('nw-re-server')
      expect(chef_run).not_to lock_user('nw-re-server')
      expect(chef_run).not_to unlock_user('nw-re-server')
    end
  end
end

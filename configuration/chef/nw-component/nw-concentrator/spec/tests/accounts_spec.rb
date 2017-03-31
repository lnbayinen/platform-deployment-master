require_relative '../spec_helper.rb'

describe 'nw-concentrator::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-concentrator']['accounts'] = [{
        'name' => 'nw-concentrator',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-concentrator').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-concentrator')
      expect(chef_run).not_to modify_group('nw-concentrator')
      expect(chef_run).not_to remove_group('nw-concentrator')

      expect(chef_run).to create_user('nw-concentrator').with(uid: 501)
      expect(chef_run).not_to manage_user('nw-concentrator')
      expect(chef_run).not_to modify_user('nw-concentrator')
      expect(chef_run).not_to remove_user('nw-concentrator')
      expect(chef_run).not_to lock_user('nw-concentrator')
      expect(chef_run).not_to unlock_user('nw-concentrator')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-concentrator']['accounts'] = [{
        'name' => 'nw-concentrator',
        'uid' => 501,
        'home' => '/home/nw-concentrator'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-concentrator').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-concentrator')
      expect(chef_run).not_to modify_group('nw-concentrator')
      expect(chef_run).not_to remove_group('nw-concentrator')

      expect(chef_run).to create_user('nw-concentrator').with(
        uid: 501, home: '/home/nw-concentrator'
      )
      expect(chef_run).not_to manage_user('nw-concentrator')
      expect(chef_run).not_to modify_user('nw-concentrator')
      expect(chef_run).not_to remove_user('nw-concentrator')
      expect(chef_run).not_to lock_user('nw-concentrator')
      expect(chef_run).not_to unlock_user('nw-concentrator')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-concentrator']['accounts'] = [{
        'name' => 'nw-concentrator',
        'uid' => 501,
        'home' => '/home/nw-concentrator',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-concentrator').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-concentrator')
      expect(chef_run).not_to modify_group('nw-concentrator')
      expect(chef_run).not_to remove_group('nw-concentrator')

      expect(chef_run).to create_user('nw-concentrator').with(
        uid: 501, home: '/home/nw-concentrator', manage_home: true
      )
      expect(chef_run).not_to manage_user('nw-concentrator')
      expect(chef_run).not_to modify_user('nw-concentrator')
      expect(chef_run).not_to remove_user('nw-concentrator')
      expect(chef_run).not_to lock_user('nw-concentrator')
      expect(chef_run).not_to unlock_user('nw-concentrator')
    end
  end
end

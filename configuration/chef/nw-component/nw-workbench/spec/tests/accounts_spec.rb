require_relative '../spec_helper.rb'

describe 'nw-workbench::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-workbench']['accounts'] = [{
        'name' => 'nw-workbench',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-workbench').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-workbench')
      expect(chef_run).not_to modify_group('nw-workbench')
      expect(chef_run).not_to remove_group('nw-workbench')

      expect(chef_run).to create_user('nw-workbench').with(uid: 501)
      expect(chef_run).not_to manage_user('nw-workbench')
      expect(chef_run).not_to modify_user('nw-workbench')
      expect(chef_run).not_to remove_user('nw-workbench')
      expect(chef_run).not_to lock_user('nw-workbench')
      expect(chef_run).not_to unlock_user('nw-workbench')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-workbench']['accounts'] = [{
        'name' => 'nw-workbench',
        'uid' => 501,
        'home' => '/home/nw-workbench'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-workbench').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-workbench')
      expect(chef_run).not_to modify_group('nw-workbench')
      expect(chef_run).not_to remove_group('nw-workbench')

      expect(chef_run).to create_user('nw-workbench').with(
        uid: 501, home: '/home/nw-workbench'
      )
      expect(chef_run).not_to manage_user('nw-workbench')
      expect(chef_run).not_to modify_user('nw-workbench')
      expect(chef_run).not_to remove_user('nw-workbench')
      expect(chef_run).not_to lock_user('nw-workbench')
      expect(chef_run).not_to unlock_user('nw-workbench')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-workbench']['accounts'] = [{
        'name' => 'nw-workbench',
        'uid' => 501,
        'home' => '/home/nw-workbench',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-workbench').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-workbench')
      expect(chef_run).not_to modify_group('nw-workbench')
      expect(chef_run).not_to remove_group('nw-workbench')

      expect(chef_run).to create_user('nw-workbench').with(
        uid: 501, home: '/home/nw-workbench', manage_home: true
      )
      expect(chef_run).not_to manage_user('nw-workbench')
      expect(chef_run).not_to modify_user('nw-workbench')
      expect(chef_run).not_to remove_user('nw-workbench')
      expect(chef_run).not_to lock_user('nw-workbench')
      expect(chef_run).not_to unlock_user('nw-workbench')
    end
  end
end

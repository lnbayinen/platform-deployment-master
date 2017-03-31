require_relative '../spec_helper.rb'

describe 'nw-log-collector::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-log-collector']['accounts'] = [{
        'name' => 'nw-log-collector',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-log-collector').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-log-collector')
      expect(chef_run).not_to modify_group('nw-log-collector')
      expect(chef_run).not_to remove_group('nw-log-collector')

      expect(chef_run).to create_user('nw-log-collector').with(uid: 501)
      expect(chef_run).not_to manage_user('nw-log-collector')
      expect(chef_run).not_to modify_user('nw-log-collector')
      expect(chef_run).not_to remove_user('nw-log-collector')
      expect(chef_run).not_to lock_user('nw-log-collector')
      expect(chef_run).not_to unlock_user('nw-log-collector')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-log-collector']['accounts'] = [{
        'name' => 'nw-log-collector',
        'uid' => 501,
        'home' => '/home/nw-log-collector'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-log-collector').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-log-collector')
      expect(chef_run).not_to modify_group('nw-log-collector')
      expect(chef_run).not_to remove_group('nw-log-collector')

      expect(chef_run).to create_user('nw-log-collector').with(
        uid: 501, home: '/home/nw-log-collector'
      )
      expect(chef_run).not_to manage_user('nw-log-collector')
      expect(chef_run).not_to modify_user('nw-log-collector')
      expect(chef_run).not_to remove_user('nw-log-collector')
      expect(chef_run).not_to lock_user('nw-log-collector')
      expect(chef_run).not_to unlock_user('nw-log-collector')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-log-collector']['accounts'] = [{
        'name' => 'nw-log-collector',
        'uid' => 501,
        'home' => '/home/nw-log-collector',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-log-collector').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-log-collector')
      expect(chef_run).not_to modify_group('nw-log-collector')
      expect(chef_run).not_to remove_group('nw-log-collector')

      expect(chef_run).to create_user('nw-log-collector').with(
        uid: 501, home: '/home/nw-log-collector', manage_home: true
      )
      expect(chef_run).not_to manage_user('nw-log-collector')
      expect(chef_run).not_to modify_user('nw-log-collector')
      expect(chef_run).not_to remove_user('nw-log-collector')
      expect(chef_run).not_to lock_user('nw-log-collector')
      expect(chef_run).not_to unlock_user('nw-log-collector')
    end
  end
end

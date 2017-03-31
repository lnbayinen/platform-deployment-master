require_relative '../spec_helper.rb'

describe 'rsa-investigate::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['rsa-investigate']['accounts'] = [{
        'name' => 'rsa-investigate',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('rsa-investigate').with(gid: 501)
      expect(chef_run).not_to manage_group('rsa-investigate')
      expect(chef_run).not_to modify_group('rsa-investigate')
      expect(chef_run).not_to remove_group('rsa-investigate')

      expect(chef_run).to create_user('rsa-investigate').with(uid: 501)
      expect(chef_run).not_to manage_user('rsa-investigate')
      expect(chef_run).not_to modify_user('rsa-investigate')
      expect(chef_run).not_to remove_user('rsa-investigate')
      expect(chef_run).not_to lock_user('rsa-investigate')
      expect(chef_run).not_to unlock_user('rsa-investigate')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['rsa-investigate']['accounts'] = [{
        'name' => 'rsa-investigate',
        'uid' => 501,
        'home' => '/home/rsa-investigate'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('rsa-investigate').with(gid: 501)
      expect(chef_run).not_to manage_group('rsa-investigate')
      expect(chef_run).not_to modify_group('rsa-investigate')
      expect(chef_run).not_to remove_group('rsa-investigate')

      expect(chef_run).to create_user('rsa-investigate').with(
        uid: 501, home: '/home/rsa-investigate'
      )
      expect(chef_run).not_to manage_user('rsa-investigate')
      expect(chef_run).not_to modify_user('rsa-investigate')
      expect(chef_run).not_to remove_user('rsa-investigate')
      expect(chef_run).not_to lock_user('rsa-investigate')
      expect(chef_run).not_to unlock_user('rsa-investigate')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['rsa-investigate']['accounts'] = [{
        'name' => 'rsa-investigate',
        'uid' => 501,
        'home' => '/home/rsa-investigate',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('rsa-investigate').with(gid: 501)
      expect(chef_run).not_to manage_group('rsa-investigate')
      expect(chef_run).not_to modify_group('rsa-investigate')
      expect(chef_run).not_to remove_group('rsa-investigate')

      expect(chef_run).to create_user('rsa-investigate').with(
        uid: 501, home: '/home/rsa-investigate', manage_home: true
      )
      expect(chef_run).not_to manage_user('rsa-investigate')
      expect(chef_run).not_to modify_user('rsa-investigate')
      expect(chef_run).not_to remove_user('rsa-investigate')
      expect(chef_run).not_to lock_user('rsa-investigate')
      expect(chef_run).not_to unlock_user('rsa-investigate')
    end
  end
end

require_relative '../spec_helper.rb'

describe 'nw-pki::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-pki']['accounts'] = [{
        'name' => 'nw-pki',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-pki').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-pki')
      expect(chef_run).not_to modify_group('nw-pki')
      expect(chef_run).not_to remove_group('nw-pki')

      expect(chef_run).to create_user('nw-pki').with(uid: 501)
      expect(chef_run).not_to manage_user('nw-pki')
      expect(chef_run).not_to modify_user('nw-pki')
      expect(chef_run).not_to remove_user('nw-pki')
      expect(chef_run).not_to lock_user('nw-pki')
      expect(chef_run).not_to unlock_user('nw-pki')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-pki']['accounts'] = [{
        'name' => 'nw-pki',
        'uid' => 501,
        'home' => '/home/nw-pki'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-pki').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-pki')
      expect(chef_run).not_to modify_group('nw-pki')
      expect(chef_run).not_to remove_group('nw-pki')

      expect(chef_run).to create_user('nw-pki').with(
        uid: 501, home: '/home/nw-pki'
      )
      expect(chef_run).not_to manage_user('nw-pki')
      expect(chef_run).not_to modify_user('nw-pki')
      expect(chef_run).not_to remove_user('nw-pki')
      expect(chef_run).not_to lock_user('nw-pki')
      expect(chef_run).not_to unlock_user('nw-pki')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-pki']['accounts'] = [{
        'name' => 'nw-pki',
        'uid' => 501,
        'home' => '/home/nw-pki',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-pki').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-pki')
      expect(chef_run).not_to modify_group('nw-pki')
      expect(chef_run).not_to remove_group('nw-pki')

      expect(chef_run).to create_user('nw-pki').with(
        uid: 501, home: '/home/nw-pki', manage_home: true
      )
      expect(chef_run).not_to manage_user('nw-pki')
      expect(chef_run).not_to modify_user('nw-pki')
      expect(chef_run).not_to remove_user('nw-pki')
      expect(chef_run).not_to lock_user('nw-pki')
      expect(chef_run).not_to unlock_user('nw-pki')
    end
  end
end

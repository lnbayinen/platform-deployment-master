require_relative '../spec_helper.rb'

describe 'nw-ipdbextractor::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-ipdbextractor']['accounts'] = [{
        'name' => 'nw-ipdbextractor',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-ipdbextractor').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-ipdbextractor')
      expect(chef_run).not_to modify_group('nw-ipdbextractor')
      expect(chef_run).not_to remove_group('nw-ipdbextractor')

      expect(chef_run).to create_user('nw-ipdbextractor').with(uid: 501)
      expect(chef_run).not_to manage_user('nw-ipdbextractor')
      expect(chef_run).not_to modify_user('nw-ipdbextractor')
      expect(chef_run).not_to remove_user('nw-ipdbextractor')
      expect(chef_run).not_to lock_user('nw-ipdbextractor')
      expect(chef_run).not_to unlock_user('nw-ipdbextractor')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-ipdbextractor']['accounts'] = [{
        'name' => 'nw-ipdbextractor',
        'uid' => 501,
        'home' => '/home/nw-ipdbextractor'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-ipdbextractor').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-ipdbextractor')
      expect(chef_run).not_to modify_group('nw-ipdbextractor')
      expect(chef_run).not_to remove_group('nw-ipdbextractor')

      expect(chef_run).to create_user('nw-ipdbextractor').with(
        uid: 501, home: '/home/nw-ipdbextractor'
      )
      expect(chef_run).not_to manage_user('nw-ipdbextractor')
      expect(chef_run).not_to modify_user('nw-ipdbextractor')
      expect(chef_run).not_to remove_user('nw-ipdbextractor')
      expect(chef_run).not_to lock_user('nw-ipdbextractor')
      expect(chef_run).not_to unlock_user('nw-ipdbextractor')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-ipdbextractor']['accounts'] = [{
        'name' => 'nw-ipdbextractor',
        'uid' => 501,
        'home' => '/home/nw-ipdbextractor',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-ipdbextractor').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-ipdbextractor')
      expect(chef_run).not_to modify_group('nw-ipdbextractor')
      expect(chef_run).not_to remove_group('nw-ipdbextractor')

      expect(chef_run).to create_user('nw-ipdbextractor').with(
        uid: 501, home: '/home/nw-ipdbextractor', manage_home: true
      )
      expect(chef_run).not_to manage_user('nw-ipdbextractor')
      expect(chef_run).not_to modify_user('nw-ipdbextractor')
      expect(chef_run).not_to remove_user('nw-ipdbextractor')
      expect(chef_run).not_to lock_user('nw-ipdbextractor')
      expect(chef_run).not_to unlock_user('nw-ipdbextractor')
    end
  end
end

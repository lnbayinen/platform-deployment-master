require_relative '../spec_helper.rb'

describe 'tmpwatch::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['tmpwatch']['accounts'] = [{
        'name' => 'tmpwatch',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('tmpwatch').with(gid: 501)
      expect(chef_run).not_to manage_group('tmpwatch')
      expect(chef_run).not_to modify_group('tmpwatch')
      expect(chef_run).not_to remove_group('tmpwatch')

      expect(chef_run).to create_user('tmpwatch').with(uid: 501)
      expect(chef_run).not_to manage_user('tmpwatch')
      expect(chef_run).not_to modify_user('tmpwatch')
      expect(chef_run).not_to remove_user('tmpwatch')
      expect(chef_run).not_to lock_user('tmpwatch')
      expect(chef_run).not_to unlock_user('tmpwatch')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['tmpwatch']['accounts'] = [{
        'name' => 'tmpwatch',
        'uid' => 501,
        'home' => '/home/tmpwatch'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('tmpwatch').with(gid: 501)
      expect(chef_run).not_to manage_group('tmpwatch')
      expect(chef_run).not_to modify_group('tmpwatch')
      expect(chef_run).not_to remove_group('tmpwatch')

      expect(chef_run).to create_user('tmpwatch').with(
        uid: 501, home: '/home/tmpwatch'
      )
      expect(chef_run).not_to manage_user('tmpwatch')
      expect(chef_run).not_to modify_user('tmpwatch')
      expect(chef_run).not_to remove_user('tmpwatch')
      expect(chef_run).not_to lock_user('tmpwatch')
      expect(chef_run).not_to unlock_user('tmpwatch')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['tmpwatch']['accounts'] = [{
        'name' => 'tmpwatch',
        'uid' => 501,
        'home' => '/home/tmpwatch',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('tmpwatch').with(gid: 501)
      expect(chef_run).not_to manage_group('tmpwatch')
      expect(chef_run).not_to modify_group('tmpwatch')
      expect(chef_run).not_to remove_group('tmpwatch')

      expect(chef_run).to create_user('tmpwatch').with(
        uid: 501, home: '/home/tmpwatch', manage_home: true
      )
      expect(chef_run).not_to manage_user('tmpwatch')
      expect(chef_run).not_to modify_user('tmpwatch')
      expect(chef_run).not_to remove_user('tmpwatch')
      expect(chef_run).not_to lock_user('tmpwatch')
      expect(chef_run).not_to unlock_user('tmpwatch')
    end
  end
end

require_relative '../spec_helper.rb'

describe 'nw-event-stream-analysis::accounts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
  end

  context 'User without home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-event-stream-analysis']['accounts'] = [{
        'name' => 'nw-event-stream-analysis',
        'uid' => 501
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-event-stream-analysis').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-event-stream-analysis')
      expect(chef_run).not_to modify_group('nw-event-stream-analysis')
      expect(chef_run).not_to remove_group('nw-event-stream-analysis')

      expect(chef_run).to create_user('nw-event-stream-analysis').with(uid: 501)
      expect(chef_run).not_to manage_user('nw-event-stream-analysis')
      expect(chef_run).not_to modify_user('nw-event-stream-analysis')
      expect(chef_run).not_to remove_user('nw-event-stream-analysis')
      expect(chef_run).not_to lock_user('nw-event-stream-analysis')
      expect(chef_run).not_to unlock_user('nw-event-stream-analysis')
    end
  end

  context 'User with home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-event-stream-analysis']['accounts'] = [{
        'name' => 'nw-event-stream-analysis',
        'uid' => 501,
        'home' => '/home/nw-event-stream-analysis'
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-event-stream-analysis').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-event-stream-analysis')
      expect(chef_run).not_to modify_group('nw-event-stream-analysis')
      expect(chef_run).not_to remove_group('nw-event-stream-analysis')

      expect(chef_run).to create_user('nw-event-stream-analysis').with(
        uid: 501, home: '/home/nw-event-stream-analysis'
      )
      expect(chef_run).not_to manage_user('nw-event-stream-analysis')
      expect(chef_run).not_to modify_user('nw-event-stream-analysis')
      expect(chef_run).not_to remove_user('nw-event-stream-analysis')
      expect(chef_run).not_to lock_user('nw-event-stream-analysis')
      expect(chef_run).not_to unlock_user('nw-event-stream-analysis')
    end
  end

  context 'User with managed home' do
    it 'creates the service account group and user' do
      chef_run.node.normal['nw-event-stream-analysis']['accounts'] = [{
        'name' => 'nw-event-stream-analysis',
        'uid' => 501,
        'home' => '/home/nw-event-stream-analysis',
        'manage_home' => true
      }]

      chef_run.converge(described_recipe)

      expect(chef_run).to create_group('nw-event-stream-analysis').with(gid: 501)
      expect(chef_run).not_to manage_group('nw-event-stream-analysis')
      expect(chef_run).not_to modify_group('nw-event-stream-analysis')
      expect(chef_run).not_to remove_group('nw-event-stream-analysis')

      expect(chef_run).to create_user('nw-event-stream-analysis').with(
        uid: 501, home: '/home/nw-event-stream-analysis', manage_home: true
      )
      expect(chef_run).not_to manage_user('nw-event-stream-analysis')
      expect(chef_run).not_to modify_user('nw-event-stream-analysis')
      expect(chef_run).not_to remove_user('nw-event-stream-analysis')
      expect(chef_run).not_to lock_user('nw-event-stream-analysis')
      expect(chef_run).not_to unlock_user('nw-event-stream-analysis')
    end
  end
end

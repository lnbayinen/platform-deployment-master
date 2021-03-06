require_relative '../spec_helper.rb'

describe 'nw-pki::groups' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-pki']['user_groups'] = [{
        'name' => 'testgroup',
        'gid' => 601,
        'members' => ['testuser']
      }]
    end.converge(described_recipe)
  end

  expected_groups = [{
    'name' => 'testgroup',
    'gid' => 601,
    'members' => ['testuser']
  }]

  expected_groups.each do |user_group|
    it "adds the user group #{user_group['name']}" do
      expect(chef_run).to create_group(user_group['name']).with(
        gid: user_group['gid'],
        members: user_group['members'],
        append: true
      )
      expect(chef_run).not_to manage_group(user_group['name'])
      expect(chef_run).not_to modify_group(user_group['name'])
      expect(chef_run).not_to remove_group(user_group['name'])
    end
  end
end

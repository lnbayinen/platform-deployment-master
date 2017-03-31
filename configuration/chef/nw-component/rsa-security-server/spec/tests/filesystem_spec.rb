require_relative '../spec_helper.rb'

describe 'rsa-security-server::filesystem' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-security-server']['filesystem'] = {
        'default_perms' => {
          'owner' => 'netwitness',
          'group' => 'netwitness',
          'dirmode' => '0750',
          'filemode' => '0640'
        },
        'directories' => [
          {
            'path' => '/tmp/test'
          }
        ],
        'symlinks' => [
          {
            'path' => '/tmp/link',
            'target' => '/tmp/test'
          }
        ]
      }
    end.converge(described_recipe)
  end

  it 'applies filesystem configuration' do
    expect(chef_run).to apply_nw_base_filesystem('rsa-security-server')
  end
end

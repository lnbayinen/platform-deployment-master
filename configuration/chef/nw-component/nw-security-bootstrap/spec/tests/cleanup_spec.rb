require_relative '../spec_helper.rb'

describe 'nw-security-bootstrap::cleanup' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-security-bootstrap']['service_names'] = %w(
        rsa-security-server
      )
    end.converge(described_recipe)
  end

  it 'deletes the systemd environment drop-in file' do
    expect(chef_run).to delete_systemd_service('rsa-security-server-security-bootstrap-managed')
  end

  it 'Restarts the rsa-security-server service' do
    expect(chef_run).to restart_service('rsa-security-server')
  end
end

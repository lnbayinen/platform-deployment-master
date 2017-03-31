require_relative '../spec_helper.rb'

describe 'nw-security-bootstrap::bootstrap' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-security-bootstrap']['service_names'] = %w(
        rsa-security-server
      )
      node.normal['nw-appliance']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
      node.normal['nw-pki']['ss_client'] = {}
      node.normal['nw-pki']['ss_client']['password'] = "test"
    end.converge(described_recipe)
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('rsa-security-server-security-bootstrap-managed')
  end

  it 'Restarts the rsa-security-server service' do
    expect(chef_run).to restart_service('rsa-security-server')
  end
end

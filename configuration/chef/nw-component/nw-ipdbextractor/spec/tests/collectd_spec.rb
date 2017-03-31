require_relative '../spec_helper.rb'

describe 'nw-ipdbextractor::collectd' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-pki']['certificates'] = [{
        'cert_pem' => '/foo/bar.pem',
        'key_pem' => '/foo/bar.key',
        'node_common' => true
      }]
      node.normal['nw-pki']['trust']['exports'] = [{
        'type' => 'pem',
        'primary' => true,
        'path' => '/foo/ca.pem'
      }]
    end.converge(described_recipe)
  end

  service_name = 'collectd'
  service_resource = "service[#{service_name}]"

  context 'When deploying the collectd configuration fragment' do
    file = '/etc/collectd.d/ipdbextractor.conf'
    properties = {
      owner: 'root',
      group: 'root',
      mode: 0o444
    }

    it 'does not log a fatal error finding the common node cert' do
      expect(chef_run).not_to write_log(
        'Unable to find Common Node Certificate'
      )
    end

    it 'sets proper ownership and permissions on the configuration file' do
      expect(chef_run).to create_template(file).with(properties)
    end

    it 'notifies the collectd service to restart on template change' do
      stub_service = chef_run.service(service_name)
      expect(stub_service).to do_nothing

      template = chef_run.template(file)
      expect(template).to notify(service_resource).to(:restart).delayed
    end

    it 'deploys the configuration file with valid cert paths' do
      expect(chef_run).to render_file(file).with_content(
        %r{\s+keypath\s+"/foo/bar.key"}
      )
      expect(chef_run).to render_file(file).with_content(
        %r{\s+certpath\s+"/foo/bar.pem"}
      )
    end
  end
end

require_relative '../spec_helper.rb'

describe 'nw-re-server::collectd' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.automatic['hostname'] = 'testing'
    end.converge(described_recipe)
  end

  service_name = 'collectd'
  service_resource = "service[#{service_name}]"

  context 'For the python script' do
    file = '/usr/lib/collectd/python/comp_modules/cs_reportingengine.py'
    properties = {
      owner: 'root',
      group: 'root',
      mode: 0o444
    }

    it 'sets proper ownership and permissions on the script' do
      expect(chef_run).to create_remote_file(file).with(properties)
    end

    it 'notifies the collectd service to restart on script deployment' do
      stub_service = chef_run.service(service_name)
      expect(stub_service).to do_nothing

      script = chef_run.remote_file(file)
      expect(script).to notify(service_resource).to(:restart).delayed
    end
  end

  context 'For the collectd configuration fragment' do
    file = '/etc/collectd.d/jmx-ReportingEngine.conf'
    properties = {
      owner: 'root',
      group: 'root',
      mode: 0o444
    }

    it 'sets proper ownership and permissions on the configuration file' do
      expect(chef_run).to create_template(file).with(properties)
    end

    it 'notifies the collectd service to restart on template change' do
      stub_service = chef_run.service(service_name)
      expect(stub_service).to do_nothing

      template = chef_run.template(file)
      expect(template).to notify(service_resource).to(:restart).delayed
    end

    it 'deploys the configuration file with the node UUID' do
      expect(chef_run).to render_file(file).with_content(/\s+Host\s+"testing"/)
    end
  end
end

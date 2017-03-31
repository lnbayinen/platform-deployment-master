require_relative '../spec_helper.rb'

describe 'rsa-audit-server::config' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-audit-server']['service_names'] = %w(
        logstash
      )
    end.converge(described_recipe)
  end

  fileOwner = 'logstash'
  fileGroup = 'logstash'
  fileMode = 0o750

  folders = [
    "/etc/logstash/conf.d"
  ]

  folders.each do |name|
    it "creates folder #{name}" do
      expect(chef_run).to create_directory(name).with(
        user: fileOwner,
        group: fileGroup,
        mode: fileMode
      )
      expect(chef_run).not_to delete_directory(name)
    end
  end

  context 'When deploying the rsa-audit-server configuration file' do
    service_name = 'logstash'
    service_resource = "service[#{service_name}]"

    file = '/etc/logstash/conf.d/rsa-audit-server.conf'
    properties = {
        owner: 'logstash',
        group: 'logstash',
        mode: 0o640
    }

    it 'sets proper ownership and permissions on the configuration file' do
      expect(chef_run).to create_cookbook_file(file).with(properties)
    end

    it 'notifies the logstash service to restart on config file change' do
      stub_service = chef_run.service(service_name)
      expect(stub_service).to do_nothing

      cookbook_file = chef_run.cookbook_file(file)
      expect(cookbook_file).to notify(service_resource).to(:restart).delayed
    end
  end
end

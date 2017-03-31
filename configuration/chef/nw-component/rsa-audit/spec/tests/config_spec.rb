require_relative '../spec_helper.rb'

describe 'rsa-audit::config' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-audit']['service_names'] = %w(
        rsyslog
      )
      node.automatic['hostname'] = 'node'
    end.converge(described_recipe)
  end

  fileOwner = 'root'
  fileGroup = 'root'
  fileMode = 0o750

  folders = [
      "/etc/rsyslog.d"
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

  context 'When deploying the rsa-audit template' do
    service_name = 'rsyslog'
    service_resource = "service[#{service_name}]"

    file = '/etc/rsyslog.d/rsa-sa-audit.conf'
    properties = {
        owner: 'root',
        group: 'root',
        mode: 0o640
    }

    it 'sets proper ownership and permissions on the configuration file' do
      expect(chef_run).to create_template(file).with(properties)
    end

    it 'notifies the rsyslog service to restart on template change' do
      stub_service = chef_run.service(service_name)
      expect(stub_service).to do_nothing

      template = chef_run.template(file)
      expect(template).to notify(service_resource).to(:restart).delayed
    end
  end

  context 'When deploying the rsa-audit configuration file' do
    service_name = 'rsyslog'
    service_resource = "service[#{service_name}]"

    file = '/etc/rsyslog.d/rsa-udp-50514.conf'
    properties = {
        owner: 'root',
        group: 'root',
        mode: 0o640
    }

    it 'sets proper ownership and permissions on the configuration file' do
      expect(chef_run).to create_cookbook_file(file).with(properties)
    end

    it 'notifies the rsyslog service to restart on template change' do
      stub_service = chef_run.service(service_name)
      expect(stub_service).to do_nothing

      cookbook_file = chef_run.cookbook_file(file)
      expect(cookbook_file).to notify(service_resource).to(:restart).delayed
    end
  end
end

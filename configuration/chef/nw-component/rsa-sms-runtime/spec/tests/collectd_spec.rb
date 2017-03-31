require_relative '../spec_helper.rb'

describe 'rsa-sms-runtime::collectd' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
    end.converge(described_recipe)
  end

  service_name = 'collectd'
  service_resource = "service[#{service_name}]"

  configs = [
    '/etc/collectd.d/_collectd_java.conf',
    '/etc/collectd.d/_collectd_logfile.conf.disabled',
    '/etc/collectd.d/_collectd_pre_filter.conf',
    '/etc/collectd.d/appliance.conf',
    '/etc/collectd.d/appliance_diskraid.conf',
    '/etc/collectd.d/MessageBus.conf',
    '/etc/collectd.d/MessageBusWriteModule.conf',
    '/etc/collectd.d/NwCompositeStats.conf',
    '/etc/collectd.d/SampleEsmReader.conf.disabled',
    '/etc/collectd.d/SampleReadModule.conf.disabled',
    '/etc/collectd.d/SampleWriteModule.conf.disabled'
  ]

  folders = [
    '/var/lib/netwitness/collectd/rrd',
    '/usr/lib/collectd/python/comp_modules'
  ]

  file_owner = 'root'
  file_group = 'root'
  file_mode = 0o644

  folders.each do |name|
    it "creates folder #{name}" do
      expect(chef_run).to create_directory(name).with(
        user: file_owner,
        group: file_group,
        mode: file_mode
      )
      expect(chef_run).not_to delete_directory(name)
    end
  end

  it 'expects the stub service to do nothing' do
    stub_service = chef_run.service(service_name)
    expect(stub_service).to do_nothing
  end

  configs.each do |name|
    it "creates configuration #{name}" do
      expect(chef_run).to create_cookbook_file(name).with(
        user: file_owner,
        group: file_group,
        mode: file_mode
      )
      expect(chef_run).not_to delete_cookbook_file(name)
      expect(chef_run).not_to touch_cookbook_file(name)
      file = chef_run.cookbook_file(name)
      expect(file).to notify(service_resource).to(:restart).delayed
    end
  end

  it 'deletes the _collectd_filter.conf file' do
    expect(chef_run).to delete_file('/etc/collectd.d/_collectd_filter.conf')
  end

  it 'creates the cs_appliance.py remote file' do
    expect(chef_run).to create_remote_file(
      '/usr/lib/collectd/python/comp_modules/cs_appliance.py'
    )
  end
end

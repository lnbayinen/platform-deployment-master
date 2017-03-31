require_relative '../spec_helper.rb'

describe 'rsa-sms-server::collectd' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
    end.converge(described_recipe)
  end

  service_name = 'collectd'
  service_resource = "service[#{service_name}]"

  configs = [
    '/etc/collectd.d/_collectd_post_filter_smsnode.conf',
    '/etc/collectd.d/_collectd_rrdtool.conf',
    '/etc/collectd.d/ESMAggregator.conf',
    '/etc/collectd.d/MessageBusReadModule.conf',
    '/etc/collectd.d/SmsAggregator.conf'
  ]

  templates = [
    '/etc/collectd.d/jmx-SystemMonitor.conf'
  ]

  folders = [
    '/var/lib/netwitness/collectd/rrd'
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

  templates.each do |name|
    it "creates configuration #{name}" do
      expect(chef_run).to create_template(name).with(
        user: file_owner,
        group: file_group,
        mode: file_mode
      )
      expect(chef_run).not_to delete_template(name)
      expect(chef_run).not_to touch_template(name)
      file = chef_run.template(name)
      expect(file).to notify(service_resource).to(:restart).delayed
    end
  end

  it 'creates the cs_appliances_down.py remote file' do
    expect(chef_run).to create_remote_file(
      '/usr/lib/collectd/python/comp_modules/cs_appliances_down.py'
    )
  end
end

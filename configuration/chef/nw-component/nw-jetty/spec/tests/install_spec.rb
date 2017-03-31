require_relative '../spec_helper.rb'

describe 'nw-jetty::install' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-jetty']['file-owner'] = 'nwuser'
      node.normal['nw-jetty']['file-group'] = 'nwgroup'
      node.normal['nw-jetty']['file-mode'] = '0640'
    end.converge(described_recipe)
  end

  file_owner = 'nwuser'
  file_group = 'nwgroup'
  file_mode = '0640'

  templates = [
    '/opt/rsa/jetty9/etc/jetty-https.xml',
    '/opt/rsa/jetty9/etc/jetty.xml',
    '/opt/rsa/jetty9/start.d/0-sa.ini',
    '/opt/rsa/jetty9/etc/jetty-ssl.xml'
  ]

  configs = [
    '/opt/rsa/jetty9/start.ini',
    '/opt/rsa/jetty9/webapps/root.xml',
    '/opt/rsa/jetty9/etc/jetty-started.xml',
    '/opt/rsa/jetty9/etc/jetty-deploy.xml',
    '/opt/rsa/jetty9/etc/jetty-logging.xml',
    '/etc/default/jetty',
    '/etc/systemd/system/jetty.service'
  ]

  scripts = [
    '/opt/rsa/jetty9/bin/jetty.sh'
  ]

  cleanup = [
    '/opt/rsa/jetty9/etc/jetty-http.xml'
  ]

  templates.each do |name|
    it "creates file from template #{name}" do
      expect(chef_run).to create_template(name).with(
        user: file_owner,
        group: file_group,
        mode: file_mode
      )
      expect(chef_run).not_to delete_template(name)
      expect(chef_run).not_to touch_template(name)
    end
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
    end
  end

  scripts.each do |name|
    it "creates script #{name}" do
      expect(chef_run).to create_cookbook_file(name).with(
        user: file_owner,
        group: file_group,
        mode: '0750'
      )
      expect(chef_run).not_to delete_cookbook_file(name)
      expect(chef_run).not_to touch_cookbook_file(name)
    end
  end

  cleanup.each do |name|
    it "removes file #{name}" do
      expect(chef_run).to delete_file(name)
      expect(chef_run).not_to create_file(name)
      expect(chef_run).not_to touch_file(name)
    end
  end

  it 'does not execute daemon reload' do
    expect(chef_run).not_to run_execute('daemon_reload_jetty')
  end
end

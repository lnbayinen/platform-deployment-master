require_relative '../spec_helper.rb'

#####
# In this test file, we purposely do not converge Chef early, but wait to do it
# at each example block in order to set differing node attributes.
#####
describe 'tmpwatch::config' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
    end.converge(described_recipe)
  end

  context 'When deploying the tmpwatch configuration file' do
    file = '/etc/cron.daily/tmpwatch'
    properties = {
        owner: 'root',
        group: 'root',
        mode: 0o755
    }

    it 'sets proper ownership and permissions on the configuration file' do
      expect(chef_run).to create_cookbook_file(file).with(properties)
    end
  end
end

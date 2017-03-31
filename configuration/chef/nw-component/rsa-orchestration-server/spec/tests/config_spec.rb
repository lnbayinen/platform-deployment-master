require_relative '../spec_helper.rb'

describe 'rsa-orchestration-server::config' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-orchestration-server']['service_names'] = %w(
        rsa-orchestration-server
      )
    end.converge(described_recipe)
  end

  tmpl = '/etc/netwitness/orchestration-server/orchestration-server.yml'
  service = 'service[rsa-orchestration-server]'

  it 'deploys the orchestration config template' do
    expect(chef_run).to render_file(tmpl)
    resource = chef_run.template(tmpl)
    expect(resource).to notify(service).to(:restart).immediately
  end
end

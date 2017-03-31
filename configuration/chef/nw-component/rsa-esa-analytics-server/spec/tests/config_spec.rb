require_relative '../spec_helper.rb'

describe 'rsa-esa-analytics-server::config' do

  esa_account = 'EsaUser'
  esa_pw = 'EsaPassword'
  esa_query_account = 'EsaQueryUser'
  esa_query_pw = 'EsaQueryPassword'
  admin_account = 'testAdminUser'
  admin_pw = 'testAdminPassword'

  
  #  defaulting the stub commands is necessary when there are multiple execute commands with command based guards.
  before do
    stub_command("mongo esa -u '#{esa_account}' -p '#{esa_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(false)
    stub_command("mongo esa -u '#{esa_query_account}' -p '#{esa_query_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(false)
  end
  
  
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-esa-analytics-server']['esa_account'] = esa_account
      node.normal['rsa-esa-analytics-server']['esa_pw'] = esa_pw
      node.normal['rsa-esa-analytics-server']['esa_query_account'] = esa_query_account
      node.normal['rsa-esa-analytics-server']['esa_query_pw'] = esa_query_pw
      node.normal['mongod']['admin_account'] = admin_account
      node.normal['mongod']['admin_pw'] = admin_pw
    end.converge(described_recipe)
  end

  context 'when esa account does not exist in mongo' do
    it 'executes the add mongo esa account command' do
      stub_command("mongo esa -u '#{esa_account}' -p '#{esa_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(true)
      expect(chef_run).to run_execute('Add esa account')
    end
  end

  context 'when esa account does exist in mongo' do
    it 'does not execute the add mongo esa account command' do
      stub_command("mongo esa -u '#{esa_account}' -p '#{esa_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(false)
      expect(chef_run).not_to run_execute('Add esa account')
    end
  end
 
  context 'when esa_query account does not exist in mongo' do
    it 'executes the add mongo esa_query account command' do
      stub_command("mongo esa -u '#{esa_query_account}' -p '#{esa_query_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(true)
      expect(chef_run).to run_execute('Add esa_query account')
    end
  end

  context 'when esa_query account does exist in mongo' do
    it 'does not execute the add mongo esa_query account command' do
      stub_command("mongo esa -u '#{esa_query_account}' -p '#{esa_query_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(false)
      expect(chef_run).not_to run_execute('Add esa_query account')
    end
  end  

end

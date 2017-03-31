require_relative '../spec_helper.rb'

describe 'nw-mongo::config' do

  admin_account = 'testUser'
  admin_pw = 'testPassword'

  before do
    stub_command("mongo admin -u '#{admin_account}' -p '#{admin_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(true)
  end
  
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['mongod']['admin_account'] = admin_account
      node.normal['mongod']['admin_pw'] = admin_pw
    end.converge(described_recipe)
  end

  context 'when mongo admin does not exist' do
    it 'executes the add mongo admin command' do
      stub_command("mongo admin -u '#{admin_account}' -p '#{admin_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(true)
      expect(chef_run).to run_execute('Add admin account')
    end
  end

  context 'when mongo admin does exist' do
    it 'does not add the mongo admin account' do
      stub_command("mongo admin -u '#{admin_account}' -p '#{admin_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(false)
      expect(chef_run).not_to run_execute('Add admin account')
    end
  end
  
  it 'validate mongo service responding' do
    expect(chef_run).to run_execute('validate mongo is up')
  end
  
end
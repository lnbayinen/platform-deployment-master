require_relative '../spec_helper.rb'

describe 'rsa-response::config' do

  im_account = 'testUser'
  im_pw = 'testPassword'
  admin_account = 'testAdminUser'
  admin_pw = 'testAdminPassword'

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-response']['im_account'] = im_account
      node.normal['rsa-response']['im_pw'] = im_pw
      node.normal['mongod']['admin_account'] = admin_account
      node.normal['mongod']['admin_pw'] = admin_pw
    end.converge(described_recipe)
  end

  context 'when im account does not exist in mongo' do
    it 'executes the add mongo im account command' do
      stub_command("mongo im -u '#{im_account}' -p '#{im_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(true)
      expect(chef_run).to run_execute('Add im account')
    end
  end

  context 'when im account does exist in mongo' do
    it 'does not execute the add mongo im account command' do
      stub_command("mongo im -u '#{im_account}' -p '#{im_pw}' --eval 'db.getUsers()' | grep 'Error: Authentication failed.'").and_return(false)
      expect(chef_run).not_to run_execute('Add im account')
    end
  end
end
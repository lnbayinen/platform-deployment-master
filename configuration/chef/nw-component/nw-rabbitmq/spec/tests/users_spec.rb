require_relative '../spec_helper.rb'

describe 'nw-rabbitmq::users' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-rabbitmq']['users'] = [{
        'name' => 'myuser',
        'administrator' => true,
        'vhosts' => [{
          'name' => '/foo/bar',
          'permissions' => '.* .* .*'
        }]
      }, {
        'name' => 'myuser2',
        'password' => 'weakpassword',
        'vhosts' => [{
          'name' => '/baz/quux',
          'permissions' => '.* .* .*'
        }]
      }, {
        'name' => 'blankpassuser',
        'password' => ''
      }]
    end.converge(described_recipe)
  end

  context 'RabbitMQ user myuser' do
    u = 'myuser'

    it "adds the RabbitMQ user #{u}" do
      expect(chef_run).to add_nw_rabbitmq_user("add #{u}")
      expect(chef_run).not_to delete_nw_rabbitmq_user("delete #{u}")
    end

    it "clears the password for RabbitMQ user #{u}" do
      expect(chef_run).to clear_password_nw_rabbitmq_user("clear_password #{u}")
      expect(chef_run).not_to change_password_nw_rabbitmq_user(
        "change_password #{u}"
      )
    end

    it "sets the RabbitMQ user #{u} to an administrator" do
      expect(chef_run).to set_tags_nw_rabbitmq_user("set_tags #{u}").with(
        tag: 'administrator'
      )
    end

    it "sets permissions for #{u} on vhost /foo/bar" do
      expect(chef_run).to set_permissions_nw_rabbitmq_user(
        "set_permissions #{u}"
      ).with(vhost: '/foo/bar', permissions: '.* .* .*')
    end
  end

  context 'RabbitMQ user myuser2' do
    u = 'myuser2'

    it "adds the RabbitMQ user #{u}" do
      expect(chef_run).to add_nw_rabbitmq_user("add #{u}")
      expect(chef_run).not_to delete_nw_rabbitmq_user("delete #{u}")
    end

    it "does not clear the password for RabbitMQ user #{u}" do
      expect(chef_run).not_to clear_password_nw_rabbitmq_user(
        "clear_password #{u}"
      )
      expect(chef_run).not_to change_password_nw_rabbitmq_user(
        "change_password #{u}"
      )
    end

    it "does not set the RabbitMQ user #{u} to administrator" do
      expect(chef_run).not_to set_tags_nw_rabbitmq_user("set_tags #{u}").with(
        tag: 'administrator'
      )
    end

    it "sets permissions for #{u} on vhost /baz/quux" do
      expect(chef_run).to set_permissions_nw_rabbitmq_user(
        "set_permissions #{u}"
      ).with(vhost: '/baz/quux', permissions: '.* .* .*')
    end
  end

  context 'RabbitMQ user with blank password' do
    u = 'blankpassuser'

    it "adds the RabbitMQ user #{u}" do
      expect(chef_run).to add_nw_rabbitmq_user("add #{u}")
      expect(chef_run).not_to delete_nw_rabbitmq_user("delete #{u}")
    end

    it "clears the password for RabbitMQ user #{u}" do
      expect(chef_run).to clear_password_nw_rabbitmq_user(
        "clear_password #{u}"
      )
      expect(chef_run).not_to change_password_nw_rabbitmq_user(
        "change_password #{u}"
      )
    end

    it "does not set the RabbitMQ user #{u} to administrator" do
      expect(chef_run).not_to set_tags_nw_rabbitmq_user("set_tags #{u}").with(
        tag: 'administrator'
      )
    end

    it "does not set any vhost permissions for #{u}" do
      expect(chef_run).not_to set_permissions_nw_rabbitmq_user(
        "set_permissions #{u}"
      )
    end
  end
end

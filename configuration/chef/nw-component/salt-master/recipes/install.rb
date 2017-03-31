# deploy salt master configuration file
cookbook_file '/etc/salt/master' do
  source 'master'
  owner node['salt-master']['file-owner']
  group node['salt-master']['file-group']
  mode node['salt-master']['file-mode']
end

directory '/etc/salt/nw/fileServer/_modules/' do
  recursive true
  owner node['salt-master']['file-owner']
  group node['salt-master']['file-group']
  mode node['salt-master']['file-mode']
end

directory '/etc/salt/nw/_reactors/' do
  recursive true
  owner node['salt-master']['file-owner']
  group node['salt-master']['file-group']
  mode node['salt-master']['file-mode']
end

template '/etc/salt/nw/fileServer/_modules/nodeinfo.py' do
  source 'nodeinfo.py'
  owner node['salt-master']['file-owner']
  group node['salt-master']['file-group']
  mode node['salt-master']['file-mode']
  notifies :restart, 'service[salt-master]', :immediately
end

template '/etc/salt/nw/_reactors/sync_modules.sls' do
  source 'sync_modules.sls'
  owner node['salt-master']['file-owner']
  group node['salt-master']['file-group']
  mode node['salt-master']['file-mode']
  notifies :restart, 'service[salt-master]', :immediately
end

service 'salt-master' do
  action :nothing
end

#
# Cookbook Name:: nw-jetty
# Recipe:: install
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

# overwrite/copy custom start.ini (removes references to jetty-http.xml)
cookbook_file '/opt/rsa/jetty9/start.ini' do
  source 'start.ini'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
end

# overwrite/copy custom jetty.sh (updates 'ulimit' values and log redirection)
cookbook_file '/opt/rsa/jetty9/bin/jetty.sh' do
  source 'bin/jetty.sh'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode '0750'
end

# create new root.xml for netwitness
cookbook_file '/opt/rsa/jetty9/webapps/root.xml' do
  source 'webapps/root.xml'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
end

# overwrite/copy custom jetty-started.xml (sets maxFormContentSize to 500000)
cookbook_file '/opt/rsa/jetty9/etc/jetty-started.xml' do
  source 'etc/jetty-started.xml'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
end

# overwrite/copy custom jetty-deploy.xml (sets scanInterval to 0)
cookbook_file '/opt/rsa/jetty9/etc/jetty-deploy.xml' do
  source 'etc/jetty-deploy.xml'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
end

# overwrite/copy custom jetty-logging.xml (sets retain days to 15)
cookbook_file '/opt/rsa/jetty9/etc/jetty-logging.xml' do
  source 'etc/jetty-logging.xml'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
end

# overwrite/copy custom jetty-ssl.xml (sets SSL/keystore/ciphers configuration)
template '/opt/rsa/jetty9/etc/jetty-ssl.xml' do
  source 'etc/jetty-ssl.xml.erb'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
end

# create new jetty configurtion (sets java_options)
cookbook_file '/etc/default/jetty' do
  source 'osroot/etc/default/jetty'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
end

# overwrite/copy custom jetty-https.xml (switches default port to 7000 and sets soLingerTime)
template '/opt/rsa/jetty9/etc/jetty-https.xml' do
  source 'etc/jetty-https.xml.erb'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
end

# overwrite/copy custom jetty.xml (switches default port to 7000)
template '/opt/rsa/jetty9/etc/jetty.xml' do
  source 'etc/jetty.xml.erb'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
end

# create new 0-sa.ini (sets listen ports and references to the https/ssl config files)
template '/opt/rsa/jetty9/start.d/0-sa.ini' do
  source 'start.d/0-sa.ini.erb'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
end

# remove jetty-http.xml (see updates for start.ini)
file '/opt/rsa/jetty9/etc/jetty-http.xml' do
  action :delete
end

# create new systemd service script (calls jetty.sh)
cookbook_file '/etc/systemd/system/jetty.service' do
  source 'osroot/etc/systemd/system/jetty.service'
  owner node['nw-jetty']['file-owner']
  group node['nw-jetty']['file-group']
  mode node['nw-jetty']['file-mode']
  notifies :run, 'execute[daemon_reload_jetty]', :immediately
end

# refresh in case of updates to jetty.service
execute 'daemon_reload_jetty' do
  command 'systemctl --system daemon-reload'
  action :nothing
end

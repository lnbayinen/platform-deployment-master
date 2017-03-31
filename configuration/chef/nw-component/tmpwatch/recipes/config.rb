#
# Cookbook Name:: tmpwatch
# Recipe:: config
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

# Manage existing tmpwatch cron daily configuration placed by rpm
cookbook_file '/etc/cron.daily/tmpwatch' do
  source 'tmpwatch.cron.daily.sh'
  owner 'root'
  group 'root'
  mode 0o755
end
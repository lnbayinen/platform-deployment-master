#
# Cookbook Name:: nw-event-stream-analysis
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-event-stream-analysis::accounts'
include_recipe 'nw-event-stream-analysis::packages'
include_recipe 'nw-event-stream-analysis::firewall'
include_recipe 'nw-event-stream-analysis::filesystem'
include_recipe 'nw-event-stream-analysis::services'
include_recipe 'nw-event-stream-analysis::serviceinfo'
include_recipe 'nw-event-stream-analysis::collectd'

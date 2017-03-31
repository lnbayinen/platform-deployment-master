# From https://github.com/rabbitmq/chef-cookbook/blob/master/providers/plugin.rb
# with minor adjustments
#
# Cookbook Name:: rabbitmq
# Provider:: plugin
#
# Copyright 2012-2013, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

use_inline_resources

def plugin_enabled?(name)
  ENV['PATH'] = "#{ENV['PATH']}:/usr/lib/rabbitmq/bin"
  cmdstr = "rabbitmq-plugins list -e '#{name}\\b'"
  cmd = Mixlib::ShellOut.new(cmdstr, env: { 'HOME' => '/var/lib/rabbitmq' })
  cmd.run_command
  Chef::Log.debug "rabbitmq_plugin_enabled?: #{cmdstr}"
  Chef::Log.debug "rabbitmq_plugin_enabled?: #{cmd.stdout}"
  cmd.error!
  cmd.stdout =~ /\b#{name}\b/
end

action :enable do
  execute "rabbitmq-plugins enable #{new_resource.plugin}" do
    umask 0o0022
    Chef::Log.info "Enabling RabbitMQ plugin '#{new_resource.plugin}'."
    environment 'PATH' => "#{ENV['PATH']}:/usr/lib/rabbitmq/bin"
    new_resource.updated_by_last_action(true)
    not_if { plugin_enabled?(new_resource.plugin) }
  end
end

action :disable do
  execute "rabbitmq-plugins disable #{new_resource.plugin}" do
    umask 0o0022
    Chef::Log.info "Disabling RabbitMQ plugin '#{new_resource.plugin}'."
    environment 'PATH' => "#{ENV['PATH']}:/usr/lib/rabbitmq/bin"
    new_resource.updated_by_last_action(true)
    only_if { plugin_enabled?(new_resource.plugin) }
  end
end

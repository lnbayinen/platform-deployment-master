#
# Cookbook Name:: nw-log-collector
# Recipe:: selinux
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs custom Selinux modules for each service that
# the /var/log/audit/audit.log has shown denials for.
#
# audit2allow can generate these rules but they MAY NOT be the ideal fixes.
#
# Proper SELinux policies may include new file contexts and changing
# the SELinux context ownerships on disk (relabeling).
#
# New booleans could also be created to properly manage permissions
# so that we don't give too much freedom to each service domain context.
#

# Generated by audit2allow for collectd
selinux_policy_module 'nw-collectd' do
  content <<-eos
      module nw-collectd 1.0;
      require {
        type user_tmp_t;
        type lib_t;
        type admin_home_t;
        type unreserved_port_t;
        type memory_device_t;
        type ephemeral_port_t;
        type collectd_t;
        type rabbitmq_var_lib_t;
        class tcp_socket name_connect;
        class chr_file getattr;
        class file { create read write };
        class dir { add_name read write remove_name rmdir };
      }
      
      #============= collectd_t ==============
      allow collectd_t admin_home_t:dir { remove_name rmdir };
      allow collectd_t lib_t:dir add_name;
      allow collectd_t lib_t:file { read create write };
      allow collectd_t memory_device_t:chr_file getattr;
      allow collectd_t rabbitmq_var_lib_t:dir read;
      allow collectd_t user_tmp_t:dir { read write };
  eos
  action :deploy
end

# Allow collectd to connect to other services
# This is a collectd created boolean
selinux_policy_boolean 'collectd_tcp_network_connect' do
  value true
end

# Generated by audit2allow for rabbitmq
selinux_policy_module 'nw-rabbitmq' do
  content <<-eos
      module nw-rabbitmq 1.0;
      
      require {
        type rabbitmq_t;
        type etc_t;
        type unreserved_port_t;
        type cert_t;
        class tcp_socket name_bind;
        class file write;
        }
      
      #============= rabbitmq_t ==============
        allow rabbitmq_t cert_t:file write;
      
      #!!!! WARNING: 'etc_t' is a base type.
        allow rabbitmq_t etc_t:file write;
      
      #!!!! This avc can be allowed using the boolean 'nis_enabled'
        allow rabbitmq_t unreserved_port_t:tcp_socket name_bind;
  eos
  action :deploy
end

# Generated by audit2allow for syslog
selinux_policy_module 'nw-syslog' do
  content <<-eos
      module nw-syslog 1.0;
      
      require {
              type syslogd_t;
              type amqp_port_t;
              class tcp_socket name_connect;
      }
      
      #============= syslogd_t ==============
        allow syslogd_t amqp_port_t:tcp_socket name_connect;
  eos
  action :deploy
end
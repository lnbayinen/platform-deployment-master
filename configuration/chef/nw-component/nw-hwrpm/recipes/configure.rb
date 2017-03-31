#
# Cookbook Name:: nw-hwrpm
# Recipe::configure 
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

if node['kernel']['modules'].key?('lpfc')
  script 'fixStartScript' do
    interpreter "bash"
    code <<-EOH
      sed -r 's/(^#[[:space:]]+pidfile:[[:space:]]+)\\/var\\/log\\/agent\.pid/\\1\\/run\\/agent.pid/' < /etc/rc.d/init.d/hostagent > /etc/rc.d/init.d/hostagent.tmp
      mv -f /etc/rc.d/init.d/hostagent.tmp /etc/rc.d/init.d/hostagent
      chown root:root /etc/rc.d/init.d/hostagent
      chmod 755 /etc/rc.d/init.d/hostagent
      systemctl enable hostagent
      systemctl start hostagent
    EOH
    only_if 'grep "/var/log/agent.pid" /etc/rc.d/init.d/hostagent'
  end 
end

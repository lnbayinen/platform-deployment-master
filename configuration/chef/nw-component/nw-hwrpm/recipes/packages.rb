#
# Cookbook Name:: nw-hwrpm
# Recipe:: packages
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-hwrpm']['packages'].each do |pkg|
  package pkg['name'] do
   version pkg['version']
     if pkg['name'] == 'HostAgent-Linux-64-x86-en_US'
       if node['kernel']['modules'].key?('lpfc')
         action :install
         next
      else
        action :nothing
        next
      end
    end
    if pkg['name'] == 'MegaCli'
      if node['kernel']['modules'].key?('megaraid_sas')
        action :install
        next
      else
        action :nothing
        next
      end
    end
    if pkg['name'] == 'OpenIPMI' or pkg['name'] == 'ipmitool' or pkg['name'] == 'lm_sensors'
      if node['kernel']['modules'].key?('ipmi_msghandler')
        action :install
        next
      else
        action :nothing
        next
      end
    end
    if pkg['name'] == 'device-mapper-multipath'
      if node['kernel']['modules'].key?('lpfc')
        action :install
        next
      else
        action :nothing
        next
      end
    end
    action :install
  end
end

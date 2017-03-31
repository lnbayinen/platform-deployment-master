#
# Cookbook Name:: nw-hwrpm
# Recipe:: services
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-hwrpm']['service_names'].each do |svc|
  service svc do
    if svc == 'hostagent'
      if node['kernel']['modules'].key?('lpfc')	    
        action [:enable, :start]
        next
      else
        action :nothing
        next 
      end
    end
    if svc == 'multipathd'
      if node['kernel']['modules'].key?('lpfc') or node['kernel']['modules'].key?('megaraid_sas')    
        action [:enable, :start]
        next
      else
        action :nothing
        next
      end
    end
    action [:enable, :start]
  end
end

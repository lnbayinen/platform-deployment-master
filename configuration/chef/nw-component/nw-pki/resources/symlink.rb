#
# Cookbook Name:: nw-pki
# Resource:: symlink
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

property :symlink, String, name_property: true
property :store_path, String, required: true

default_action :create

action :create do
  link_folder = ::File.dirname(symlink)

  directory link_folder do
    recursive true
    action :create
  end

  link symlink do
    to store_path
  end
end

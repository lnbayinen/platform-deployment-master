#
# Cookbook Name:: nw-pki
# Resource:: filesystem
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#
# Applies the filesystem configuration specified in the component descriptor.
# Supports directories, files, and symlinks as well as custom file permissions.
#
# This is a reusable resource for use by other cookbooks.  Sample usage:
#  nw_base_filesystem '<cookbook-name>' do
#    action :apply
#  end
#
# NOTE: the filesystem configuration (from component descriptor) is read from
# the node attributes based on the specified cookbook-name.  The filesystem
# configuration is expected to be found at node[<cookbook-name>]['filesystem'].
# See component descriptor documentation for details.
#
# Custom support for recursive folders is necessary since the built-in Chef
# directory resource's "recursive" feature will only apply the specified
# group/owner/mode attributes to the leaf folder and NOT any parent folders
# that are created as a result of the recursive feature.
#

property :nw_cookbook_name, String, name_property: true

default_action :apply

action :apply do
  fs = node[nw_cookbook_name]['filesystem']

  # list of folders processed
  observed = []

  # process directories
  unless fs.nil? || fs['directories'].nil?
    fs['directories'].each do |folder|
      if folder['perms']
        # use the specified folder permissions
        owner = folder['perms']['owner']
        group = folder['perms']['group']
        mode = folder['perms']['mode']
      elsif fs['default_perms']
        # use default permissions instead
        owner = fs['default_perms']['owner']
        group = fs['default_perms']['group']
        mode = fs['default_perms']['dirmode']
      else
        # no folder or default permissions specified (use chef defaults)
        owner = nil
        group = nil
        mode = nil
      end

      if folder['recursive']
        # create any undeclared parent folders recursively as needed
        unless folder['base'].nil? || folder['path'].start_with?(folder['base'])
          Chef::Log.fatal('Invalid recursive folder base!')
          Chef::Log.fatal("#{folder['base']} not an ancestor of #{folder['path']}")
          raise
        end

        # whether or not parent base found so we can start creating folders
        rbase_found = false

        # current folder path being processed recursively
        current_path = ''

        folder['path'].split('/').each do |name|
          next if name.empty?
          current_path = "#{current_path}/#{name}"

          unless rbase_found
            if folder['base'].nil? && observed.include?(current_path)
              # no base specified but we found a declared parent
              rbase_found = true
            elsif current_path == folder['base']
              # base specified and we just found the match
              rbase_found = true
            end
            next
          end

          # skip if this is a duplicate
          next if observed.include?(current_path)

          observed << current_path
          directory current_path do
            owner owner unless owner.nil?
            group group unless group.nil?
            mode mode unless mode.nil?
            action :create
          end
        end

        unless rbase_found
          # done with recurisve folders but no parent base found...
          Chef::Log.fatal("Could not process #{folder['path']} - no common base found!")
          raise
        end

      else
        # not recursive, just create the folder
        observed << folder['path']
        directory folder['path'] do
          owner owner unless owner.nil?
          group group unless group.nil?
          mode mode unless mode.nil?
          action :create
        end
      end
    end
  end

  # process cookbook files
  unless fs.nil? || fs['files'].nil?
    fs['files'].each do |cfile|
      if cfile['perms']
        # use the specified file permissions
        owner = cfile['perms']['owner']
        group = cfile['perms']['group']
        mode = cfile['perms']['mode']
      elsif fs['default_perms']
        # use default permissions instead
        owner = fs['default_perms']['owner']
        group = fs['default_perms']['group']
        mode = fs['default_perms']['filemode']
      else
        # no file or default permissions specified (use chef defaults)
        owner = nil
        group = nil
        mode = nil
      end

      cookbook_file cfile['path'] do
        source cfile['source']
        owner owner unless owner.nil?
        group group unless group.nil?
        mode mode unless mode.nil?
      end
    end
  end

  # process symlinks
  unless fs.nil? || fs['symlinks'].nil?
    fs['symlinks'].each do |symlink|
      link symlink['path'] do
        to symlink['target']
      end
    end
  end
end

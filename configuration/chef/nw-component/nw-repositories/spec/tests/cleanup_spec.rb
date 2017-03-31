#
# Cookbook Name:: asoc-repo
# Spec:: default
#
# Copyright (c) 2016 RSA Security, All Rights Reserved.

require 'spec_helper'

describe 'nw-repositories::cleanup' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  removal = %w(
    CentOS-Base
    CentOS-CR
    CentOS-Debuginfo
    CentOS-fasttrack
    CentOS-Media
    CentOS-Sources
    CentOS-Vault
  )
  removal.each do |reponame|
    it "deletes the #{reponame} repository" do
      expect(chef_run).to delete_yum_repository("Remove #{reponame} repository")
    end
  end
end

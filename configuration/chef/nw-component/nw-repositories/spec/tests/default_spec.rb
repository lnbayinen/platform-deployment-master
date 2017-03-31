#
# Cookbook Name:: asoc-repo
# Spec:: default
#
# Copyright (c) 2016 RSA Security, All Rights Reserved.

require 'spec_helper'

describe 'nw-repositories::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end
end

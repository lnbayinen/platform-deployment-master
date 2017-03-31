#
# Cookbook Name:: asoc-repo
# Spec:: default
#
# Copyright (c) 2016 RSA Security, All Rights Reserved.

require 'spec_helper'

describe 'nw-repositories::add' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  it 'creates the libhq repository' do
    expect(chef_run).to create_yum_repository('Add libhq')
  end
end

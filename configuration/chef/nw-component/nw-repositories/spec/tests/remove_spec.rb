#
# Cookbook Name:: asoc-repo
# Spec:: default
#
# Copyright (c) 2016 RSA Security, All Rights Reserved.

require 'spec_helper'

describe 'nw-repositories::remove' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  it 'removes the libhq repository' do
    expect(chef_run).to delete_yum_repository('Remove libhq')
  end
end

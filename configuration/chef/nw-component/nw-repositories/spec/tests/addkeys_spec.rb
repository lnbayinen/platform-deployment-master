#
# Cookbook Name:: asoc-repo
# Spec:: addkeys
#
# Copyright (c) 2016 RSA Security, All Rights Reserved.

require 'spec_helper'

describe 'nw-repositories::addkeys' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  keys = %w(
    RPM-GPG-KEY-CentOS-7
    RPM-GPG-KEY-EPEL-7
    RPM-GPG-KEY-RSA-Dev
    RPM-GPG-KEY-RSA-Prod
    erlang_solutions.asc
    mongodb-server-3.2.asc
    nginx_signing.key
    rabbitmq-release-signing-key.asc
  )

  keys.each do |key|
    key_path = ::File.join('/etc/pki/rpm-gpg', key)
    subscriber = "execute[add RPM GPG key #{key}]"

    it "deploys the #{key} GPG key" do
      expect(chef_run).to create_cookbook_file(key_path)

      resource = chef_run.cookbook_file(key_path)
      expect(resource).to notify(subscriber).to(:run).immediately
    end

    it "adds the #{key} GPG key to RPM" do
      resource = chef_run.execute("add RPM GPG key #{key}")
      expect(resource).to do_nothing
    end
  end
end

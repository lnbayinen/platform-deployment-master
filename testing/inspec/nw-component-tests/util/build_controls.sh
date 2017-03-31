#!/bin/bash
## Iterating through a static list is deprecated
#for i in `cat component_list.txt`;
# From now on we generate individual inspec stubs as script arguments
# or by the help of pipes. Example: ./build_controls.sh nw-foobar
# The generated controls file will be under generated_tests directory.
for i in "$@"
do
    tee generated_tests/${i}.rb << EOF
# rubocop:disable Style/FileName
# rubocop:disable Lint/AmbiguousRegexpLiteral

# InSpec Control file for ${i} NetWitness 11 component


# Component firewall testing
control '${i}-firewall' do
  impact 1.0
  title '${i}-firewall test'
  desc 'Ensure all firewall rules have been applied'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')
  if node_json['${i}']['firewall_rules']
    node_json['${i}']['firewall_rules'].each do |rule|
      case rule['protocol']
      when 'tcp'
        rule['ports'].each do |port_num|
          describe command('firewall-cmd --direct --get-all-rules') do
            its('stdout') { should match /-p tcp .* --dports \S*#{port_num}/ }
          end
        end
      when 'udp'
        rule['ports'].each do |port_num|
          describe command('firewall-cmd --direct --get-all-rules') do
            its('stdout') { should match /-p udp .* --dports \S*#{port_num}/ }
          end
        end
      end
    end
  end
end

# # Component port testing
# control '${i}-ports' do
#   impact 1.0
#   title '${i}-prts test'
#   desc 'Ensure all component service ports are listening'
#
#   # Read data from node.json
#   node_json = json('/opt/rsa/platform/nw-chef/node.json')
#   if node_json['${i}']['firewall_rules']
#     node_json['${i}']['firewall_rules'].each do |rule|
#       case rule['protocol']
#       when 'tcp'
#         rule['ports'].each do |port_num|
#           describe port(port_num) do
#             it { should be_listening }
#             its('protocols') { should include('tcp').or include('tcp6') }
#             its('addresses') { should include('0.0.0.0').or include('::') }
#           end
#         end
#       when 'udp'
#         rule['ports'].each do |port_num|
#           describe port(port_num) do
#             it { should be_listening }
#             its('protocols') { should include('udp').or include('udp6') }
#             its('addresses') { should include('0.0.0.0').or include('::') }
#           end
#         end
#       end
#     end
#   end
# end

# Component Accounts Testing
control '${i}-accounts' do
  impact 1.0
  title '${i}-accounts test'
  desc 'Ensure service or system have been applied'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  node_json['${i}']['accounts'].each do |account|
    describe user(account['name']) do
      it { should exist }
      its('uid') { should eq account['uid'] }
    end
    if account['home']
      describe file(account['home']) do
        it { should be_directory }
      end
    end
  end
end

# Component RPM Package testing
control '${i}-packages' do
  impact 1.0
  title '${i}-packages test'
  desc 'Ensure all have been installed and they are in the correct version'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  node_json['${i}']['packages'].each do |package|
    describe package(package['name']) do
      it { should be_installed }
      if package['version']
          its('version') { should eq package['version'] }
      end
    end
  end
end

# Component service testing
control '${i}-services' do
  impact 1.0
  title '${i}-services test'
  desc 'Ensure all component services are running'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  if node_json['${i}']['service_names']
    node_json['${i}']['service_names'].each do |service_name|
      describe service(service_name) do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
      end
    end
  end
end


# Directories and symlinks testing
control '${i}-filesystem' do
  impact 1.0
  title '${i}-filesystem'
  desc 'Ensure various directories and symlinks are present'
  node_json = json('/opt/rsa/platform/nw-chef/node.json')
  if node_json['${i}']['filesystem']
    if node_json['${i}']['filesystem']['directories']
      node_json['${i}']['filesystem']['directories'].each do |directory|
        describe file(directory['path']) do
          it {should be_directory}
        end
      end
    end
    if node_json['${i}']['filesystem']['symlinks']
      node_json['${i}']['filesystem']['symlinks'].each do |symlink|
        describe file(symlink['path']) do
          it { should be_symlink }
        end
        # This is to work around InSpec bug https://github.com/chef/inspec/issues/974
        describe command("/bin/readlink -n #{symlink['path']}") do
          its('stdout') { should eq symlink['target']}
        end
      end
    end
  end
end



EOF
done

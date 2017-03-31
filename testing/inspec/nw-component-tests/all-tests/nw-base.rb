# rubocop:disable Style/FileName
# rubocop:disable Lint/AmbiguousRegexpLiteral

# InSpec Control file for nw-base NetWitness 11 component


# Component firewall testing
control 'nw-base-firewall' do
  impact 1.0
  title 'nw-base-firewall test'
  desc 'Ensure all firewall rules have been applied'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')
  if node_json['nw-base']['firewall_rules']
    node_json['nw-base']['firewall_rules'].each do |rule|
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
# control 'nw-base-ports' do
#   impact 1.0
#   title 'nw-base-prts test'
#   desc 'Ensure all component service ports are listening'
#
#   # Read data from node.json
#   node_json = json('/opt/rsa/platform/nw-chef/node.json')
#   if node_json['nw-base']['firewall_rules']
#     node_json['nw-base']['firewall_rules'].each do |rule|
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
control 'nw-base-accounts' do
  impact 1.0
  title 'nw-base-accounts test'
  desc 'Ensure service or system have been applied'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  node_json['nw-base']['accounts'].each do |account|
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
control 'nw-base-packages' do
  impact 1.0
  title 'nw-base-packages test'
  desc 'Ensure all have been installed and they are in the correct version'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  node_json['nw-base']['packages'].each do |package|
    describe package(package['name']) do
      it { should be_installed }
      if package['version']
          its('version') { should eq package['version'] }
      end
    end
  end
end

# Component service testing
control 'nw-base-services' do
  impact 1.0
  title 'nw-base-services test'
  desc 'Ensure all component services are running'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  if node_json['nw-base']['service_names']
    node_json['nw-base']['service_names'].each do |service_name|
      describe service(service_name) do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
      end
    end
  end
end

# Component collectd testing
control 'nw-base-collectd-collectd-conf' do
    impact 1.0
    title 'nw-base-collectd-collectd-conf'
    desc 'Ensure /etc/collectd.conf file is present'
    describe file('/etc/collectd.conf') do
        it {should be_file}
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('mode') { should cmp '0444' }
        its('size') { should > 0 }
    end
end

## Commening the following tests until a better solution is provided -- spanog
## Component serviceID verification on Node-Z / Node-X
#control 'salt-minion-services-ServiceID-verification' do
#  impact 1.0
#  title 'salt-minion-ServiceID-verification test'
#  desc 'Ensure all installed serviceID are accessed'
#
#  node_json = json('/opt/rsa/platform/nw-chef/node.json')
#
#  # service-ID's are created for the services belonging to the below families only
#  familyArray = ['carlos','third_party','launch','nextgen']
#
#  node_json['run_list'].each do |service_installed|
#
#      # get the service name from the run_list ; this is returned as a array of size 1
#      service_name =  service_installed.match(/recipe\[(.*)\]/).captures
#
#      # for each of the services, see if it is a launch,third_party,nextgen carlos service, if it is the service_id file should exist
#      if familyArray.include?(node_json[service_name[0]]['family'])
#
#          service_file_name =  '/etc/netwitness/platform/nodeinfo/' +node_json[service_name[0]]['component_name']+ '/service-id'
#
#          describe file(service_file_name) do
#            it { should be_file }
#            its('size') { should > 0 }
#            #its('content') { should match /service-id=.*/ }
#            its('content') { should match /service-id=\S*/ }
#          end
#      end
#  end
#end

# Directories and symlinks testing
control 'nw-base-filesystem' do
  impact 1.0
  title 'nw-base-filesystem'
  desc 'Ensure various directories and symlinks are present'
  node_json = json('/opt/rsa/platform/nw-chef/node.json')
  if node_json['nw-base']['filesystem']
    if node_json['nw-base']['filesystem']['directories']
      node_json['nw-base']['filesystem']['directories'].each do |directory|
        describe file(directory['path']) do
          it {should be_directory}
        end
      end
    end
    if node_json['nw-base']['filesystem']['symlinks']
      node_json['nw-base']['filesystem']['symlinks'].each do |symlink|
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

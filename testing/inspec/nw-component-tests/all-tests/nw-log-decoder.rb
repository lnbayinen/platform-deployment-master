# rubocop:disable Style/FileName
# rubocop:disable Lint/AmbiguousRegexpLiteral

# InSpec Control file for nw-log-decoder NetWitness 11 component


# Component firewall testing
control 'nw-log-decoder-firewall' do
  impact 1.0
  title 'nw-log-decoder-firewall test'
  desc 'Ensure all firewall rules have been applied'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')
  if node_json['nw-log-decoder']['firewall_rules']
    node_json['nw-log-decoder']['firewall_rules'].each do |rule|
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
# control 'nw-log-decoder-ports' do
#   impact 1.0
#   title 'nw-log-decoder-prts test'
#   desc 'Ensure all component service ports are listening'
#
#   # Read data from node.json
#   node_json = json('/opt/rsa/platform/nw-chef/node.json')
#   if node_json['nw-log-decoder']['firewall_rules']
#     node_json['nw-log-decoder']['firewall_rules'].each do |rule|
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
control 'nw-log-decoder-accounts' do
  impact 1.0
  title 'nw-log-decoder-accounts test'
  desc 'Ensure service or system have been applied'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  node_json['nw-log-decoder']['accounts'].each do |account|
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
control 'nw-log-decoder-packages' do
  impact 1.0
  title 'nw-log-decoder-packages test'
  desc 'Ensure all have been installed and they are in the correct version'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  node_json['nw-log-decoder']['packages'].each do |package|
    describe package(package['name']) do
      it { should be_installed }
      if package['version']
          its('version') { should eq package['version'] }
      end
    end
  end
end

# Component service testing
control 'nw-log-decoder-services' do
  impact 1.0
  title 'nw-log-decoder-services test'
  desc 'Ensure all component services are running'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  if node_json['nw-log-decoder']['service_names']
    node_json['nw-log-decoder']['service_names'].each do |service_name|
      describe service(service_name) do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
      end
    end
  end
end

# Component service status testing
control 'nw-log-decoder-service-status' do
  impact 1.0
  title 'nw-log-decoder-service-status'
  desc 'Ensure LogDecoder service returns Ready'

  svc_check = 'curl --silent admin:netwitness@localhost:50102/sys/stats/service.status | grep Ready | sed "s/<string>//g" | sed "s/<\/string>//g"| tr -d "[:blank:]" | tr -d "\n"'

  describe command(svc_check) do
    its('stdout') { should eq 'Ready' }
  end
end

# Component collectd testing
control 'nw-logdecoder-collectd-logdecoder-conf' do
    impact 1.0
    title 'nw-logdecoder-collectd-logdecoder-conf'
    desc 'Ensure /etc/collectd.d/logdecoder-esm.conf file is present'
    describe file('/etc/collectd.d/logdecoder-esm.conf') do
        it {should be_file}
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('mode') { should cmp '0444' }
        its('size') { should > 0 }
    end
end


control 'nw-logdecoder-collectd-cs_logdecoder-lib' do
    impact 1.0
    title 'nw-logdecoder-collectd-cs_logdecoder-lib'
    desc 'Ensure /usr/lib/collectd/python/comp_modules/cs_logdecoder.py file is present'
    describe file('/usr/lib/collectd/python/comp_modules/cs_logdecoder.py') do
        it {should be_file}
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('mode') { should cmp '0444' }
        its('size') { should > 0 }
    end
end


# Directories and symlinks testing
control 'nw-log-decoder-filesystem' do
  impact 1.0
  title 'nw-log-decoder-filesystem'
  desc 'Ensure various directories and symlinks are present'
  node_json = json('/opt/rsa/platform/nw-chef/node.json')
  if node_json['nw-log-decoder']['filesystem']
    if node_json['nw-log-decoder']['filesystem']['directories']
      node_json['nw-log-decoder']['filesystem']['directories'].each do |directory|
        describe file(directory['path']) do
          it {should be_directory}
        end
      end
    end
    if node_json['nw-log-decoder']['filesystem']['symlinks']
      node_json['nw-log-decoder']['filesystem']['symlinks'].each do |symlink|
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

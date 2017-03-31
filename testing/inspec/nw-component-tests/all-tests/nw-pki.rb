# rubocop:disable Style/FileName
# rubocop:disable Lint/AmbiguousRegexpLiteral

# InSpec Control file for nw-pki NetWitness 11 component

require 'json'

# Component firewall testing
control 'nw-pki-firewall' do
  impact 1.0
  title 'nw-pki-firewall test'
  desc 'Ensure all firewall rules have been applied'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')
  if node_json['nw-pki']['firewall_rules']
    node_json['nw-pki']['firewall_rules'].each do |rule|
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
# control 'nw-pki-ports' do
#   impact 1.0
#   title 'nw-pki-prts test'
#   desc 'Ensure all component service ports are listening'
#
#   # Read data from node.json
#   node_json = json('/opt/rsa/platform/nw-chef/node.json')
#   if node_json['nw-pki']['firewall_rules']
#     node_json['nw-pki']['firewall_rules'].each do |rule|
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
control 'nw-pki-accounts' do
  impact 1.0
  title 'nw-pki-accounts test'
  desc 'Ensure service or system have been applied'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  node_json['nw-pki']['accounts'].each do |account|
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
control 'nw-pki-packages' do
  impact 1.0
  title 'nw-pki-packages test'
  desc 'Ensure all have been installed and they are in the correct version'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  node_json['nw-pki']['packages'].each do |package|
    describe package(package['name']) do
      it { should be_installed }
      if package['version']
          its('version') { should eq package['version'] }
      end
    end
  end
end

# Component service testing
control 'nw-pki-services' do
  impact 1.0
  title 'nw-pki-services test'
  desc 'Ensure all component services are running'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  if node_json['nw-pki']['service_names']
    node_json['nw-pki']['service_names'].each do |service_name|
      describe service(service_name) do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
      end
    end
  end
end

# Directories and symlinks testing
control 'nw-pki-filesystem' do
  impact 1.0
  title 'nw-pki-filesystem'
  desc 'Ensure various directories and symlinks are present'
  node_json = json('/opt/rsa/platform/nw-chef/node.json')
  if node_json['nw-pki']['filesystem']
    if node_json['nw-pki']['filesystem']['directories']
      node_json['nw-pki']['filesystem']['directories'].each do |directory|
        describe file(directory['path']) do
          it {should be_directory}
        end
      end
    end
    if node_json['nw-pki']['filesystem']['symlinks']
      node_json['nw-pki']['filesystem']['symlinks'].each do |symlink|
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

control 'nw-pki-trust-peer-cert' do
    impact 1.0
    title 'nw-pki-trust-peer-cert'
    desc 'Ensure trust peer certificate file is present'
    node_json = json('/opt/rsa/platform/nw-chef/node.json')
    if node_json['nw-pki']['trust_peer']
        cert_file_location = node_json['nw-pki']['trust_peer']['cert_pem']
        describe file(cert_file_location) do
            it {should be_file}
            its('owner') { should eq 'netwitness' }
            its('group') { should eq 'nwpki' }
            its('mode') { should cmp '0640' }
            its('size') { should > 0 }
        end
    end
end

control 'nw-pki-ca-cert-key-pem' do
    impact 1.0
    title 'nw-pki-ca-cert-key-pem'
    desc 'Ensure nw-pki-ca-cert-key-pem  is present'
    node_json = json('/opt/rsa/platform/nw-chef/node.json')

    if node_json['nw-pki']['ca']
      cert_file_location = node_json['nw-pki']['ca']['cert_pem']
      describe file(cert_file_location) do
        it {should be_file}
        its('owner') { should eq 'netwitness' }
        its('group') { should eq 'nwpki' }
        its('mode') { should cmp '0640' }
        its('size') { should > 0 }
      end

      cert_file_location = node_json['nw-pki']['ca']['cert_meta']
      describe file(cert_file_location) do
        it {should be_file}
        its('owner') { should eq 'netwitness' }
        its('group') { should eq 'nwpki' }
        its('mode') { should cmp '0640' }
        its('size') { should > 0 }
      end
    end
end

control 'nw-pki-exports-jks-pkcs12-pairpem' do
    impact 1.0
    title 'nw-pki-exports-jks-pkcs12-pairpem'
    desc 'Ensure jks-pkcs12-pairpem are present'
    node_json = json('/opt/rsa/platform/nw-chef/node.json')

    if node_json['nw-pki']['certificates']
      node_json['nw-pki']['certificates'].each do |data|
        data['exports'].each do |element|
          describe file(element['path']) do
            it {should be_file}
            its('size') { should > 0 }
          end
          if element['symlinks']
            element['symlinks'].each do |link|
              describe file(link) do
                it { should be_symlink }
              end
            end
          end
        end
        describe file(data['cert_pem']) do
          it {should be_file}
          its('owner') { should eq data['perms']['owner'] }
          its('group') { should eq data['perms']['group'] }
          its('mode') { should cmp data['perms']['mode'].to_i(8) }
        end
        describe file(data['key_pem']) do
          it {should be_file}
          its('owner') { should eq data['perms']['owner'] }
          its('group') { should eq data['perms']['group'] }
          its('mode') { should cmp data['perms']['mode'].to_i(8) }
        end
      end
    end
end

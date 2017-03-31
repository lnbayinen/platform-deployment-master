# rubocop:disable Style/FileName
# rubocop:disable Lint/AmbiguousRegexpLiteral

# InSpec Control file for nw-hwrpm NetWitness 11 component


# Component firewall testing
control 'nw-hwrpm-firewall' do
  impact 1.0
  title 'nw-hwrpm-firewall test'
  desc 'Ensure all firewall rules have been applied'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')
  if node_json['nw-hwrpm']['firewall_rules']
    node_json['nw-hwrpm']['firewall_rules'].each do |rule|
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
# control 'nw-hwrpm-ports' do
#   impact 1.0
#   title 'nw-hwrpm-prts test'
#   desc 'Ensure all component service ports are listening'
#
#   # Read data from node.json
#   node_json = json('/opt/rsa/platform/nw-chef/node.json')
#   if node_json['nw-hwrpm']['firewall_rules']
#     node_json['nw-hwrpm']['firewall_rules'].each do |rule|
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
control 'nw-hwrpm-accounts' do
  impact 1.0
  title 'nw-hwrpm-accounts test'
  desc 'Ensure service or system have been applied'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  node_json['nw-hwrpm']['accounts'].each do |account|
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
control 'nw-hwrpm-packages' do
  impact 1.0
  title 'nw-hwrpm-packages test'
  desc 'Ensure all have been installed and they are in the correct version'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  node_json['nw-hwrpm']['packages'].each do |package|
    # skip specific package tests unless hardware devices are present
    if package['name'] == 'HostAgent-Linux-64-x86-en_US' or package['name'] == 'device-mapper-multipath'
      lsmodout = command('lsmod | grep lpfc') 
      if not lsmodout.stdout() =~ /lpfc/
        puts "not running test for package: #{package['name']}, hardware driver not loaded"
        next
      end 
    elsif package['name'] == 'MegaCli'
      lsmodout = command('lsmod | grep megaraid_sas') 
      if not lsmodout.stdout() =~ /megaraid_sas/
        puts "not running test for package: #{package['name']}, hardware driver not loaded"
        next
      end 
    elsif package['name'] == 'OpenIPMI' or package['name'] == 'ipmitool' or package['name'] == 'lm_sensors'
      lsmodout = command('lsmod | grep ipmi_msghandler') 
      if not lsmodout.stdout() =~ /ipmi_msghandler/
        puts "not running test for package: #{package['name']}, hardware driver not loaded"
        next
      end 
    end	  
    describe package(package['name']) do
      it { should be_installed }
      if package['version']
          its('version') { should eq package['version'] }
      end
    end
  end
end

# Component service testing
control 'nw-hwrpm-services' do
  impact 1.0
  title 'nw-hwrpm-services test'
  desc 'Ensure all component services are running'

  # Read data from node.json
  node_json = json('/opt/rsa/platform/nw-chef/node.json')

  if node_json['nw-hwrpm']['service_names']
    node_json['nw-hwrpm']['service_names'].each do |service_name|
      # skip specific service tests unless hardware devices and/or configuration files are present
      if service_name == 'hostagent'
        lsmodout = command('lsmod | grep lpfc') 
        if not lsmodout.stdout() =~ /lpfc/
          puts "not running test for service: #{service_name}, hardware driver not loaded"
          next
        end
      elsif service_name == 'multipathd'
        lsmodout = command('lsmod | grep lpfc') 
        if not lsmodout.stdout() =~ /lpfc/
          puts "not running test for service: #{service_name}, hardware driver not loaded"
          next
        end
        cfgfile = command('ls /etc/multipath.conf')
        lsout = cfgfile.stdout()
        if not lsout =~ /\/etc\/multipath\.conf/
          puts "not running test for service: #{service_name}, config file not found"
   	  next
        end
      end	    
      describe service(service_name) do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
      end
    end
  end
end


# Directories and symlinks testing
control 'nw-hwrpm-filesystem' do
  impact 1.0
  title 'nw-hwrpm-filesystem'
  desc 'Ensure various directories and symlinks are present'
  node_json = json('/opt/rsa/platform/nw-chef/node.json')
  if node_json['nw-hwrpm']['filesystem']
    if node_json['nw-hwrpm']['filesystem']['directories']
      node_json['nw-hwrpm']['filesystem']['directories'].each do |directory|
        describe file(directory['path']) do
          it {should be_directory}
        end
      end
    end
    if node_json['nw-hwrpm']['filesystem']['symlinks']
      node_json['nw-hwrpm']['filesystem']['symlinks'].each do |symlink|
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




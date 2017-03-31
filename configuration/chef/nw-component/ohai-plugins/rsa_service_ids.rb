Ohai.plugin(:RSAServiceIDs) do
  provides 'rsa_service_ids'

  collect_data do
    rsa_service_ids Mash.new
    root_path = '/etc/netwitness/platform/nodeinfo'
    Dir.chdir(root_path)
    Dir.glob('**/service-id').each do |file|
      component = File.dirname(file)
      Ohai::Log.debug("Found RSA component #{component}")
      rsa_service_ids[component.to_sym] = nil
      content = File.read(file)
      content.match(/^service-id=(.+)/) { |m| content = m[1] }
      rsa_service_ids[component.to_sym] = content
    end
  end
end

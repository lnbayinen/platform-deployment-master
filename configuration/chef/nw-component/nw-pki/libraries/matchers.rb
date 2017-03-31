if defined?(ChefSpec)
  def create_nw_pki_certificate(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_pki_certificate, :create, resource_name
    )
  end

  def create_nw_pki_keystore(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_pki_keystore, :create, resource_name
    )
  end

  def create_nw_pki_truststore(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_pki_truststore, :create, resource_name
    )
  end

  def create_nw_pki_symlink(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_pki_symlink, :create, resource_name
    )
  end
end

if defined?(ChefSpec)
  def apply_nw_base_filesystem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_base_filesystem, :apply, resource_name
    )
  end
end

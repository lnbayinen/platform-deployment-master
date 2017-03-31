if defined?(ChefSpec)

  ###
  # RabbitMQ broker federation defintion
  ##

  ChefSpec.define_matcher :nw_rabbitmq_federation

  def create_nw_rabbitmq_federation(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_federation, :create, resource_name
    )
  end

  def remove_nw_rabbitmq_federation(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_federation, :remove, resource_name
    )
  end

  ###
  # RabbitMQ plugin management
  ##

  ChefSpec.define_matcher :nw_rabbitmq_plugin

  def enable_nw_rabbitmq_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_plugin, :enable, resource_name
    )
  end

  def disable_nw_rabbitmq_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_plugin, :disable, resource_name
    )
  end

  ###
  # RabbitMQ policy definition
  ##

  ChefSpec.define_matcher :nw_rabbitmq_policy

  # rubocop:disable Style/AccessorMethodName
  def set_nw_rabbitmq_policy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_policy, :set, resource_name
    )
  end
  # rubocop:enable Style/AccessorMethodName

  def clear_nw_rabbitmq_policy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_policy, :clear, resource_name
    )
  end

  def list_nw_rabbitmq_policy
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_policy, :list, nil
    )
  end

  ###
  # RabbitMQ user management
  ##

  ChefSpec.define_matcher :nw_rabbitmq_user

  def add_nw_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_user, :add, resource_name
    )
  end

  def delete_nw_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_user, :delete, resource_name
    )
  end

  # rubocop:disable Style/AccessorMethodName
  def set_permissions_nw_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_user, :set_permissions, resource_name
    )
  end
  # rubocop:enable Style/AccessorMethodName

  def clear_permissions_nw_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_user, :clear_permissions, resource_name
    )
  end

  # rubocop:disable Style/AccessorMethodName
  def set_tags_nw_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_user, :set_tags, resource_name
    )
  end
  # rubocop:enable Style/AccessorMethodName

  def clear_tags_nw_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_user, :clear_tags, resource_name
    )
  end

  def change_password_nw_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_user, :change_password, resource_name
    )
  end

  def clear_password_nw_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_user, :clear_password, resource_name
    )
  end

  ###
  # RabbitMQ vhosts
  ##

  ChefSpec.define_matcher :nw_rabbitmq_vhost

  def add_nw_rabbitmq_vhost(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_vhost, :add, resource_name
    )
  end

  def delete_nw_rabbitmq_vhost(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :nw_rabbitmq_vhost, :delete, resource_name
    )
  end
end

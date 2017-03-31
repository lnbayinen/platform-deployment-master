#
# Cookbook Name:: rabbitmq
# Resource:: federation
#

default_action :create

property :name, String, name_property: true, required: true
property :policy_name, String, required: true

# General properties (policy)
property :pattern, String, required: true
property :all_upstreams, [TrueClass, FalseClass], default: false
property :upstream_set, String

# General properties (parameter)
property :uri, String, regex: %r{amqps?:\/\/.*}, required: true
property :prefetch_count, Integer
property :reconnect_delay, Integer
property :ack_mode, String, equal_to: %w(on-confirm on-publish no-ack)
property :trust_user_id, [TrueClass, FalseClass]
property :apply_to, String, equal_to: %w(queues exchanges all)

# Exchange-related properties
property :exchange, String
property :max_hops, Integer
property :expires, Integer
property :message_ttl, Integer
property :ha_policy, String

# Queue-related properties
property :queue, String

# Remote broker properties
property :host, String, default: '127.0.0.1'
property :port, Integer, default: 15_672
property :user, String, default: 'guest'
property :pass, String, default: 'guest'
property :vhost, String, default: '/'
property :ca_file, String, required: true

action_class do
  def connection_data
    {
      host: host,
      port: port,
      user: user,
      pass: pass,
      vhost: vhost,
      ca_file: ca_file
    }
  end

  # rubocop:disable Metrics/MethodLength
  def federation_parameter
    {
      name: name,
      uri: uri,
      exchange: exchange,
      expires: expires,
      queue: queue,
      'prefetch-count' => prefetch_count,
      'reconnect-delay' => reconnect_delay,
      'ack-mode' => ack_mode,
      'max-hops' => max_hops,
      'message-ttl' => message_ttl,
      'ha-policy' => ha_policy
    }
  end
  # rubocop:enable Metrics/MethodLength

  def federation_policy
    data = { pattern: pattern, apply_to: apply_to, definition: {} }
    if all_upstreams
      data[:definition][%s(federation-upstream)] = name
    elsif upstream_set && !upstream_set.empty?
      data[:definition][%s(federation-upstream-set)] = upstream_set
    else
      data[:definition][%s(federation-upstream-set)] = 'all'
    end
    data
  end

  include NwRabbitMQ::REST::Federation
  include NwRabbitMQ::REST::Policy
end

action :create do
  unless upstream?(federation_parameter, connection_data) # ~FC023
    converge_by "Adding federation upstream definition for #{uri}" do
      upstream(federation_parameter, connection_data)
    end
  end
  unless policy?(name, connection_data) # ~FC023
    converge_by "Adding federation policy definition for #{name}" do
      policy(policy_name, federation_policy, connection_data)
    end
  end
end

action :remove do
  if upstream?(federation_parameter, connection_data) # ~FC023
    converge_by "Removing federation upstream definition for #{uri}" do
      remove_upstream(federation_parameter, connection_data)
    end
  end
  if policy?(name, connection_data) # ~FC023
    converge_by "Removing federation policy definition for #{name}" do
      remove_policy(policy_name, connection_data)
    end
  end
end

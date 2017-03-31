module NwRabbitMQ
  module REST
    # Helper module to manage policies on a remote broker.
    #
    module Policy
      include NwRabbitMQ::REST

      # Returns true if the specified vhost has a policy with a matching name.
      #
      # @param name [String] Name for the policy
      # @param connection [Hash] remote broker connection parameters
      # @option connection [String] :host ('127.0.0.1') IP or hostname of the
      #   remote broker
      # @option connection [String] :port (15672) Port number of the remote
      #   broker
      # @option connection [String] :user ('guest') Username for the REST API
      # @option connection [String] :pass ('guest') Password for the REST API
      # @option connection [String] :vhost Name of the target vhost
      # @return [Boolean] Whether the policy is defined
      def policy?(name, connection)
        connection[:path] = api_path('policies', connection[:vhost], name)

        policies = with_http_error_handling { rmq_get(connection) }

        # True only if not empty and has a matching entry
        !policies.select { |u| u['name'].eql?(name) }.empty?
      end

      # Creates a new policy using the specified parameters.
      #
      # @param name [String] Name for the policy
      # @param policy [Hash] policy parameters
      # @option policy [String] :pattern Regular expression pattern to match
      #   queue names
      # @option policy [Hash] :definition Key and value pairs to apply to the
      # @option policy [String] :apply_to Queues, exchanges, or all
      #   policy
      # @param connection [Hash] remote broker connection parameters
      # @option connection [String] :host ('127.0.0.1') IP or hostname of the
      #   remote broker
      # @option connection [String] :port (15672) Port number of the remote
      #   broker
      # @option connection [String] :user ('guest') Username for the REST API
      # @option connection [String] :pass ('guest') Password for the REST API
      # @option connection [String] :vhost Name of the target vhost
      # @return [void]
      def policy(name, policy, connection)
        connection[:path] = api_path(
          'policies', connection[:vhost], name
        )
        data = {
          pattern: policy[:pattern],
          definition: policy[:definition],
          'apply-to' => policy[:apply_to]
        }

        with_http_error_handling { rmq_put(connection, data) }
      end

      # Removes an existing policy.
      #
      # @param name [String] Name for the policy
      # @param connection [Hash] remote broker connection parameters
      # @option connection [String] :host ('127.0.0.1') IP or hostname of the
      #   remote broker
      # @option connection [String] :port (15672) Port number of the remote
      #   broker
      # @option connection [String] :user ('guest') Username for the REST API
      # @option connection [String] :pass ('guest') Password for the REST API
      # @option connection [String] :vhost Name of the target vhost
      # @return [void]
      def remove_policy(name, connection)
        connection[:path] = api_path('policies', connection[:vhost], name)

        with_http_error_handling { rmq_delete(connection) }
      end
    end
  end
end

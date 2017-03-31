module NwRabbitMQ
  # Methods for utilizing RabbitMQ's REST API (exposed by the management
  # plugin).
  #
  module REST
    # Helper module for the federation LWRP.
    #
    module Federation
      include NwRabbitMQ::REST

      # Returns true if the specified vhost has a federation upstream with
      # a matching name and URI.
      #
      # @param upstream [Hash] upstream parameters
      # @option upstream [String] :name Name for the upstream
      # @option upstream [String] :uri AMQP URI
      # @param connection [Hash] remote broker connection parameters
      # @option connection [String] :host ('127.0.0.1') IP or hostname of the
      #   remote broker
      # @option connection [String] :port (15672) Port number of the remote
      #   broker
      # @option connection [String] :user ('guest') Username for the REST API
      # @option connection [String] :pass ('guest') Password for the REST API
      # @option connection [String] :vhost Name of the target vhost
      # @return [Boolean] Whether the upstream is defined
      # rubocop:disable Metrics/AbcSize
      def upstream?(upstream, connection)
        connection[:path] = api_path(
          'parameters/federation-upstream', connection[:vhost], upstream[:name]
        )

        upstreams = with_http_error_handling { rmq_get(connection) }

        # True only if not empty and has a matching entry
        !upstreams.select do |u|
          u['name'].eql?(upstream[:name]) &&
            u['value']['uri'].eql?(upstream[:uri])
        end.empty?
      end
      # rubocop:enable Metrics/AbcSize

      # Creates a new federation upstream using the specified parameters.
      # The possible keys for upstream beyond name and uri are documented on
      # http://www.rabbitmq.com/federation-reference.html
      #
      # @param upstream [Hash] upstream parameters
      # @option upstream [String] :name Name for the upstream
      # @option upstream [String] :uri AMQP URI
      # @param connection [Hash] remote broker connection parameters
      # @option connection [String] :host ('127.0.0.1') IP or hostname of the
      #   remote broker
      # @option connection [String] :port (15672) Port number of the remote
      #   broker
      # @option connection [String] :user ('guest') Username for the REST API
      # @option connection [String] :pass ('guest') Password for the REST API
      # @option connection [String] :vhost Name of the target vhost
      # @return [void]
      def upstream(upstream, connection)
        connection[:path] = api_path(
          'parameters/federation-upstream', connection[:vhost], upstream[:name]
        )
        upstream.delete(:name)
        upstream.reject! { |_, v| v.nil? }
        data = { value: upstream }

        with_http_error_handling { rmq_put(connection, data) }
      end

      # Removes an existing upstream using the AMQP URI.
      #
      # @param upstream [Hash] upstream parameters
      # @option upstream [String] :name Name for the upstream
      # @param connection [Hash] remote broker connection parameters
      # @option connection [String] :host ('127.0.0.1') IP or hostname of the
      #   remote broker
      # @option connection [String] :port (15672) Port number of the remote
      #   broker
      # @option connection [String] :user ('guest') Username for the REST API
      # @option connection [String] :pass ('guest') Password for the REST API
      # @option connection [String] :vhost Name of the target vhost
      # @return [void]
      def remove_upstream(upstream, connection)
        connection[:path] = api_path(
          'parameters/federation-upstream', connection[:vhost], upstream[:name]
        )

        with_http_error_handling { rmq_delete(connection) }
      end
    end
  end
end

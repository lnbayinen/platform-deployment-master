require 'net/http'
require 'json'

module NwRabbitMQ
  # Support methods for the Federation and Policy modules. Not intended
  # for direct consumption.
  #
  module REST
    # :nodoc:
    def rmq_get(connection)
      rmq_rest('get', connection)
    end

    # :nodoc:
    def rmq_put(connection, data)
      rmq_rest('put', connection, JSON.generate(data))
    end

    # :nodoc:
    def rmq_delete(connection)
      rmq_rest('delete', connection)
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    # :nodoc:
    def rmq_rest(method, conn, body = nil)
      uri = URI::HTTPS.build(
        host: conn[:host] || '127.0.0.1',
        port: conn[:port] || 15_672,
        path: conn[:path] || '/'
      )

      header = { 'Content-Type' => 'application/json' }
      klass = "Net::HTTP::#{method.downcase.capitalize}"

      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true
      http.ca_file = conn[:ca_file]
      # FIXME: Switch back to VERIFY_PEER
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Object.const_get(klass).new(uri, header)
      req.basic_auth(conn[:user] || 'guest', conn[:pass] || 'guest')
      req.body = body unless body.nil?

      res = http.start { |h| h.request(req) }
      res.value

      return JSON.parse(res.body) unless res.body.nil? || res.body.empty?
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # :nodoc:
    def with_http_error_handling
      yield
    rescue Net::HTTPServerException => e
      response = e.response
      return [] if response.code.to_i == 404
      errmsg = format(
        '%s: %s %s', response.uri, response.code, response.message.dump
      )
      raise response.error_type.new(errmsg, response)
    end

    # :nodoc:
    def api_path(element, vhost, name = nil)
      args = [
        '/api',
        element,
        URI.encode(vhost, '/')
      ]
      args << name unless name.nil?
      args.join('/')
    end
  end
end

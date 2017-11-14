module ActiveServiceClient

  class << self

    attr_accessor :payload, :headers, :endpoints, :endpoints_path

    def configure(&block)
      block.call self
    end

  end


  class Base

    attr_accessor :endpoint, :client

    def initialize(client: nil, endpoint: nil)
      @endpoint = endpoint || self.class.endpoint
      @client = client || RestClient
    end

    def get(resource:, headers: {})
      client.get uri(resource), merge_headers(headers)
    end

    def post(resource:, params: {}, headers: {})
      client.post uri(resource), merge_request_body(params), merge_headers(headers)
    end

    def put(resource:, params: {}, headers: {})
      client.put uri(resource), merge_request_body(params), merge_headers(headers)
    end

    def patch(resource:, params: {}, headers: {})
      client.patch uri(resource), merge_request_body(params), merge_headers(headers)
    end

    def delete(resource:, headers: {})
      client.delete uri(resource), merge_headers(headers)
    end

    def uri(resource)
      URI.join(endpoint, resource).to_s
    end

    def merge_request_body(params)
      params.is_a?(Hash) ? self.class.payload.to_h.merge(params) : params
    end

    def merge_headers(headers)
      global_headers = self.class.headers.to_h.inject({}) do |merged_headers, (key, value)|
        header = value.respond_to?(:call) ? { key => value.call(Thread.current[:request]) } : { key => value }
        merged_headers.merge(header)
      end
      global_headers.merge(headers.to_h)
    end

    class << self

      attr_accessor :endpoints

      def endpoints
        if @endpoints.nil?
          endpoints_template = ERB.new File.new(Rails.root.join(endpoints_path)).read
          @endpoints = YAML.load endpoints_template.result(binding)
        end
        @endpoints
      end

      def endpoints_path
        ActiveServiceClient.endpoints_path ||= 'config/endpoints.yml'
      end

      def headers
        ActiveServiceClient.headers || {}
      end

      def payload
        ActiveServiceClient.payload || {}
      end

      def endpoint(env: ENV['RAILS_ENV'], service: self.service)
        self.endpoints[env][service]
      end

      def service(service = nil)
        @service = service unless service.nil?
        if @service.nil?
          @service = get_service_name
        end
        @service
      end

      def get_service_name
        service = self.name
        service.slice! 'Client'
        service.underscore
      end

    end
  end
end

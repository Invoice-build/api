# frozen_string_literal: true

require 'net/http'

module EthUtilsApp
  class Client
    attr_reader :host, :port

    def initialize
      @host = ENV.fetch('ETH_UTILS_API_HOST', 'eth-utils-api')
      @port = ENV.fetch('ETH_UTILS_API_PORT', 3001)
    end

    def get(endpoint)
      request = Net::HTTP::Get.new("/#{endpoint}", headers)
      response = http.request(request)
      handle(response)
    end

    private

    def headers
      {
        'Content-Type' => 'application/json'
      }
    end

    def http
      http = Net::HTTP.new(host, port)
      http.read_timeout = 60 * 5
      http
    end

    def handle(response)
      case response
      when Net::HTTPOK
        JSON.parse(response.body)
      else
        error = JSON.parse(response.body)
        raise StandardError, error.dig('errors') if error.dig('errors')
      end
    end
  end
end

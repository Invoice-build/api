# frozen_string_literal: true

require 'net/http'
require 'infura/api/transactions'

module Infura
  class Client
    include Api::Transactions

    attr_reader :project_id, :project_secret, :host, :base_path, :debug

    DOMAIN = 'infura.io'
    VERSION = 'v3'

    def initialize(network: 'mainnet')
      @project_id     = Creds.fetch(:infura, :project_id)
      @project_secret = Creds.fetch(:infura, :project_secret)
      @host           = "#{network}.#{DOMAIN}"
      @base_path      = "/#{VERSION}/#{project_id}"
      @debug          = false
    end

    def post(method:, params: nil)
      Net::HTTP::Post.new(base_path, headers)
                     .tap { |r| (r.body = payload(method, params).to_json) unless params.nil? }
                     .tap { |r| r.basic_auth nil, project_secret }
                     .yield_self { |r| request(r, host) }
    end

    private

    def payload(method, params)
      {
        jsonrpc: '2.0',
        method: method,
        params: params,
        id: 1
      }
    end

    def headers
      {
        'User-Agent' => 'invoice.build',
        'Content-Type' => 'application/json'
      }
    end

    def config(http)
      http.use_ssl = true
      http.set_debug_output($stderr) if debug
    end

    def request(request, host)
      Net::HTTP.new(host, 443)
               .tap { |http| config(http) }
               .start { |http| http.request(request) }
               .yield_self { |response| handle(response) }
    end

    def handle(response)
      case response
      when Net::HTTPNotFound     then nil
      when Net::HTTPUnauthorized then raise 'Client not authorized'
      when Net::HTTPSuccess      then parse(response)
      else raise response.body
      end
    end

    def parse(response)
      case response['Content-Type']&.split(';')&.first
      when 'application/json' then response.body.present? && JSON.parse(response.body)['result'] || true
      else raise 'unexpected response content type'
      end
    end
  end
end

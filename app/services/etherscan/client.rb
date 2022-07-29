# frozen_string_literal: true

require 'open-uri'

module Etherscan
  class Client
    attr_reader :url, :api_key

    PROTOCOL = 'https://'
    DOMAIN = 'etherscan.io'
    BASE_PATH = '/api'

    def initialize(network: 'mainnet')
      subdomain = network == 'mainnet' ? 'api' : "api-#{network}"
      @url = "#{PROTOCOL}#{subdomain}.#{DOMAIN}#{BASE_PATH}"
      @api_key = Creds.fetch(:etherscan, :api_key)
    end

    def get_block_number
      proxy('eth_blockNumber').read.then(&method(:parse))
    end

    def get_block_by_number(number)
      proxy('eth_getBlockByNumber', tag: number, boolean: true).read.then(&method(:parse))
    end

    def get_transaction_by_hash(txhash)
      proxy('eth_getTransactionByHash', txhash: txhash).read.then(&method(:parse))
    end

    def get_transaction_receipt(txhash)
      proxy('eth_getTransactionReceipt', txhash: txhash).read.then(&method(:parse))
    end

    def get_list_of_transaction(startblock, address)
      account('txlist', { address: address, startblock: startblock, endblock: 99999999 }).read.then(&method(:parse))
    end

    def account(method, params = {})
      URI.parse(url + "?module=account&action=#{method}&#{params.to_query}&apiKey=#{api_key}")
    end

    def proxy(method, params = {})
      URI.parse(url + "?module=proxy&action=#{method}&#{params.to_query}&apiKey=#{api_key}")
    end

    def parse(response)
      case response.status[0].to_i
      when 200..226
        JSON.parse(response).dig('result')
      else
        raise response.status[1].to_s
      end
    end
  end
end

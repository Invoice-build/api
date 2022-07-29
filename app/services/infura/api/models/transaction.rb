# frozen_string_literal: true

module Infura
  module Api
    module Models
      class Transaction
        attr_reader :client

        def initialize(client)
          @client = client
        end

        def get(tx_hash:)
          client.post(method: 'eth_getTransactionByHash', params: [tx_hash])
        end
      end
    end
  end
end

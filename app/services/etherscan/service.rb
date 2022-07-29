# frozen_string_literal: true

module Etherscan
  class Service
    attr_reader :network

    def initialize(network: 'mainnet')
      @network = network
    end

    def get_confirmations(txhash)
      tx = client.get_transaction_receipt(txhash)
      bn = client.get_block_number
      return false unless tx
      return false unless tx.dig('blockNumber')
      return false unless tx.dig('status').hex == 1

      bn.to_i(16) - tx.dig('blockNumber').to_i(16) + 1
    end

    def get_confirmed_at(txhash)
      tx = client.get_transaction_receipt(txhash)
      return false unless tx
      return false unless tx.dig('blockNumber')
      return false unless tx.dig('status').hex == 1

      block = client.get_block_by_number(tx.dig('blockNumber'))

      Time.at(block.dig('timestamp').hex)
    end

    def find_confirmed_transaction(startblock:, nonce:, address:)
      return false unless startblock
      return false unless nonce
      return false unless address

      list = client.get_list_of_transaction(startblock, address)
      return false unless list.any?

      list.find { |tx| tx.dig('txreceipt_status').hex == 1 && tx.dig('nonce') == nonce }
    end

    private

    def client
      @client ||= Client.new(network: network)
    end
  end
end

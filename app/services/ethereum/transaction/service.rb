# frozen_string_literal: true

module Ethereum
  module Transaction
    class Service
      include Utils
      attr_reader :eth_transaction, :network_client_class, :eth_utils_client

      def initialize(eth_transaction, network_client_class: Infura::Client, eth_utils_client: EthUtilsApp::Client.new)
        @eth_transaction = eth_transaction
        @network_client_class = network_client_class
        @eth_utils_client = eth_utils_client
      end

      def fetch_data
        data = network_client.transactions.get(tx_hash: eth_transaction.tx_hash)
        input_data = if native_tx?(data)
                       nil
                     else
                       token = Token.where('lower(address) = ?', data['to'].downcase).take
                       eth_utils_client.get("#{token.standard}/decode/#{data['input']}")
                     end

        eth_transaction.update!(data: data, input_data: input_data)
        Worker.perform_later('validate', eth_transaction_id: eth_transaction.id)
      end

      def validate
        eth_transaction.update!(transactable_valid: Validator.new(eth_transaction).call)
      end

      private

      def native_tx?(data)
        data['input'] == '0x' || from_wei(Integer(data['value'])).positive?
      end

      def network_client
        @network_client ||= network_client_class.new(network: eth_transaction.network)
      end
    end
  end
end

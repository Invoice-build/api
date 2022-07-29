# frozen_string_literal: true

module Ethereum
  module Transaction
    class InputData
      attr_reader :eth_transaction, :token

      def initialize(eth_transaction, token_address)
        @eth_transaction = eth_transaction
        @token = Token.where('lower(address) = ?', token_address.downcase).take
      end

      def call
        case token.standard.to_sym
        when :erc20
          Serializers::Erc20InputData.new(input_data).call
        end
      end

      private

      def input_data
        @input_data ||= eth_transaction.input_data
      end
    end
  end
end

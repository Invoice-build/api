# frozen_string_literal: true

module Ethereum
  module Transaction
    class Validator < SimpleDelegator
      def call
        valid_token? && valid_network?
      end

      def valid_token?
        token == transactable&.token
      end

      def valid_network?
        network == transactable&.network
      end
    end
  end
end

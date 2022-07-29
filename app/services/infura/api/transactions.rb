# frozen_string_literal: true

module Infura
  module Api
    module Transactions
      def transactions
        @transactions ||= Models::Transaction.new(self)
      end
    end
  end
end

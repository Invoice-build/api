# frozen_string_literal: true

module Ethereum
  module Transaction
    class Details < SimpleDelegator
      include Utils

      def call
        {
          from: _data.from,
          to: recipient,
          amount: amount,
          native: native?,
          token_address: token_address
        }
      end

      def recipient
        @recipient ||= if native?
                         _data.to
                       else
                         _input_data.recipient
                       end
      end

      def value
        from_wei Integer(_data.value)
      end

      def amount
        @amount ||= if native?
                      value
                    elsif _token.decimals != 18
                      _input_data.amount * 10**(18 - _token.decimals)
                    else
                      _input_data.amount
                    end
      end

      def native?
        _data.input == '0x' || value.positive?
      end

      def token_address
        @token_address ||= if native?
                             genesis_address
                           else
                             _data.to
                           end
      end

      private

      def _data
        @_data ||= OpenStruct.new(data)
      end

      def _input_data
        @_input_data ||= OpenStruct.new(InputData.new(self, token_address).call)
      end

      def _token
        @_token ||= Token.where('lower(address) = ? AND network = ?', token_address&.downcase, network).take
      end
    end
  end
end

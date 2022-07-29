# frozen_string_literal: true

module Ethereum
  module Transaction
    module Serializers
      class Erc20InputData
        include Utils

        attr_reader :data

        def initialize(data)
          @data = data
        end

        def call
          result = {}
          result['contract_method'] = data['method']
          data['names'].each_with_index do |key, index|
            result[key] = value_for(key, index)
          end
          result
        end

        private

        def value_for(key, index)
          case key.to_sym
          when :amount
            from_wei(data['inputs'][index].to_i(16))
          when :recipient
            "0x#{data['inputs'][index]}"
          else
            data['inputs'][index]
          end
        end
      end
    end
  end
end

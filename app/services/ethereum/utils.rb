# frozen_string_literal: true

module Ethereum
  module Utils
    module_function

    def from_wei(value)
      value / 1e18
    end

    def genesis_address
      '0x0000000000000000000000000000000000000000'
    end
  end
end

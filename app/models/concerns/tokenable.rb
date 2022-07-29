# frozen_string_literal: true

module Tokenable
  extend ActiveSupport::Concern

  def from_units(value)
    value / 1e6
  end

  def to_units(value)
    (BigDecimal(value.to_s) * 1e6.to_i).to_i
  end

  class_methods do
    def tokenize(attribute, as:, validate: true)
      if validate
        validates as.to_sym, presence: true
        validates as.to_sym, numericality: { less_than: 100_000_000, greater_than: 0 }
      end

      class_eval do
        define_method(as) do
          self[attribute] ? from_units(self[attribute]) : nil
        end

        define_method("#{as}=") do |value|
          self[attribute] = to_units(value)
        end
      end
    end
  end
end

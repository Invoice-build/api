# frozen_string_literal: true

module Addressable
  extend ActiveSupport::Concern

  included do
    has_one :address, as: :addressable
    accepts_nested_attributes_for :address, reject_if: :all_blank
  end
end

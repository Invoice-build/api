# frozen_string_literal: true

module Transactable
  extend ActiveSupport::Concern

  included do
    has_many :eth_transactions, as: :transactable
  end
end

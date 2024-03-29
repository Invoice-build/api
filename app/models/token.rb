# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id         :uuid             not null, primary key
#  code       :text
#  address    :text
#  network    :text             default("mainnet")
#  decimals   :integer          default(18)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  standard   :text             default("erc20")
#
class Token < ApplicationRecord
  # ASSOCIATIONS
  has_many :invoices

  # VALIDATIONS
  validates :code, :address, presence: true
  validates :address, uniqueness: true, unless: -> { address == Ethereum::Utils.genesis_address }

  # SCOPES
  scope :mainnet, -> { where(network: 'mainnet') }
  scope :goerli, -> { where(network: 'goerli') }
  scope :polygon, -> { where(network: 'polygon') }
  scope :by_network, ->(network) { where(network: network) }
end

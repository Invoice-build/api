# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id                :uuid             not null, primary key
#  number            :text
#  token_id          :text
#  due_at            :datetime
#  description       :text
#  tax_bps           :integer          default(0)
#  payment_address   :text
#  issuer_contact_id :text
#  client_contact_id :text
#  account_id        :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  network           :text             default("mainnet")
#  password_digest   :text
#
class Invoice < ApplicationRecord
  # CONCERNS
  has_secure_password validations: false
  include Transactable
  include Tokenable

  # ASSOCIATIONS
  has_many :line_items, dependent: :destroy
  belongs_to :token
  belongs_to :issuer_contact, class_name: 'Contact', foreign_key: 'issuer_contact_id', optional: -> { encrypted? }
  belongs_to :client_contact, class_name: 'Contact', foreign_key: 'client_contact_id', optional: -> { encrypted? }

  accepts_nested_attributes_for :issuer_contact, :client_contact
  accepts_nested_attributes_for :line_items, allow_destroy: true

  # VALIDATIONS
  validates :number, :payment_address, :line_items, :network, :issuer_contact, :client_contact, presence: true, if: -> { !encrypted? }
  validates :network, :data_hash, presence: true, if: -> { encrypted? }
  validates :number, :payment_address, :line_items, :issuer_contact, :client_contact, :description, absence: true, if: -> { encrypted? }

  # METHODS
  def encrypted?
    data_hash?
  end

  def subtotal
    from_units(line_items.sum(:amount_units))
  end

  def tax
    subtotal * tax_multiplier
  end

  def total
    tax + subtotal
  end

  def paid?
    paid_amount >= total
  end

  def paid_amount
    eth_transactions.confirmed.valid.payments.map(&:details).sum { |x| x[:amount] } || 0
  end

  private

  def tax_multiplier
    tax_bps.to_f / 10_000.0
  end
end

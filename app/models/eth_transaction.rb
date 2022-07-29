# frozen_string_literal: true

# == Schema Information
#
# Table name: eth_transactions
#
#  id                 :uuid             not null, primary key
#  tx_hash            :text
#  reference          :text
#  confirmed_at       :datetime
#  failed_at          :datetime
#  transactable_id    :uuid
#  transactable_type  :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  network            :text             default("mainnet")
#  data               :jsonb
#  input_data         :jsonb
#  transactable_valid :boolean          default(FALSE)
#
class EthTransaction < ApplicationRecord
  # CALLBACKS
  after_create :poll_for_confirmation, :fetch_data

  # ASSOCIATIONS
  belongs_to :transactable, polymorphic: true

  # VALIDATIONS
  validates :tx_hash, :reference, :network, :transactable_id, :transactable_type, presence: true

  # SCOPES
  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :valid, -> { where(transactable_valid: true) }
  scope :payments, -> { where(reference: 'payment') }

  def status
    return 'failed' if failed_at?
    return 'confirmed' if confirmed_at?

    'pending'
  end

  def native?
    details[:native]
  end

  def token
    @token ||= Token.where('lower(address) = ? AND network = ?', details[:token_address]&.downcase, network).take
  end

  def details
    return {} unless data

    @details ||= Ethereum::Transaction::Details.new(self).call
  end

  private

  def poll_for_confirmation
    PollForConfirmationJob.perform_later(id)
  end

  def fetch_data
    Ethereum::Transaction::Worker.perform_later('fetch_data', eth_transaction_id: id)
  end
end

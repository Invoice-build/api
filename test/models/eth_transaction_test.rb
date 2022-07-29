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
require 'test_helper'

class EthTransactionTest < ActiveSupport::TestCase
  describe 'eth transaction' do
    def setup
      @invoice = create(:invoice, :with_line_item)
      @eth_transaction = create(:eth_transaction, transactable: @invoice)
    end

    it 'has correct #status' do
      assert_equal @eth_transaction.status, 'pending'
      @eth_transaction.update_attribute(:confirmed_at, Time.now)
      assert_equal @eth_transaction.status, 'confirmed'
      @eth_transaction.update_attribute(:failed_at, Time.now)
      assert_equal @eth_transaction.status, 'failed'
    end

    it 'is #native?' do
      assert @eth_transaction.native?
    end

    it 'has #token' do
      assert_equal @eth_transaction.token, Token.find_by(code: 'ETH')
    end

    it 'has #details' do
      assert_not @eth_transaction.details.empty?
    end
  end

  describe 'erc20 transaction' do
    def setup
      @invoice = create(:invoice, :erc20, :with_line_item)
      @eth_transaction = create(:eth_transaction, :erc20, transactable: @invoice)
    end

    it 'has correct #status' do
      assert_equal @eth_transaction.status, 'pending'
      @eth_transaction.update_attribute(:confirmed_at, Time.now)
      assert_equal @eth_transaction.status, 'confirmed'
      @eth_transaction.update_attribute(:failed_at, Time.now)
      assert_equal @eth_transaction.status, 'failed'
    end

    it 'is not #native?' do
      assert_not @eth_transaction.native?
    end

    it 'has #token' do
      assert_equal @eth_transaction.token, Token.find_by(code: 'DAI')
    end

    it 'has #details' do
      assert_not @eth_transaction.details.empty?
    end
  end
end

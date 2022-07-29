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
require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  # describe 'eth invoice' do
  #   def setup
  #     @line_items = [
  #       build(:line_item, quantity: 1, unit_price_units: 100e6),
  #       build(:line_item, quantity: 1, unit_price_units: 200e6),
  #       build(:line_item, quantity: 1, unit_price_units: 300e6)
  #     ]
  #     @invoice = create(:invoice, tax_bps: 1000, line_items: @line_items)
  #   end

  #   it 'has correct #subtotal' do
  #     puts @invoice.tax
  #     assert_equal @invoice.subtotal, 600
  #   end

  #   it 'has correct #tax' do
  #     assert_equal @invoice.tax, 60
  #   end

  #   it 'has correct #total' do
  #     assert_equal @invoice.total, 660
  #   end

  #   it 'has correct #paid_amount' do
  #     create(:eth_transaction, :confirmed, transactable: @invoice)
  #     assert_equal @invoice.paid_amount, 0.001
  #   end
  # end

  # describe 'erc20 invoice' do
  #   def setup
  #     @line_items = [
  #       build(:line_item, quantity: 1, unit_price_units: 100e6),
  #       build(:line_item, quantity: 1, unit_price_units: 200e6),
  #       build(:line_item, quantity: 1, unit_price_units: 300e6)
  #     ]
  #     @invoice = create(:invoice, :erc20, tax_bps: 1000, line_items: @line_items)
  #   end

  #   it 'has correct #subtotal' do
  #     puts @invoice.tax
  #     assert_equal @invoice.subtotal, 600
  #   end

  #   it 'has correct #tax' do
  #     assert_equal @invoice.tax, 60
  #   end

  #   it 'has correct #total' do
  #     assert_equal @invoice.total, 660
  #   end

  #   it 'has correct #paid_amount' do
  #     create(:eth_transaction, :confirmed, transactable: @invoice)
  #     assert_equal @invoice.paid_amount, 0.001
  #   end
  # end

  describe 'unencrypted invoice' do
    def setup
      @line_items = [
        build(:line_item, quantity: 1, unit_price_units: 100e6),
        build(:line_item, quantity: 1, unit_price_units: 200e6),
        build(:line_item, quantity: 1, unit_price_units: 300e6)
      ]
    end

    it 'is valid' do
      invoice = build(:invoice, tax_bps: 1000, line_items: @line_items)
      assert invoice.valid?
    end

    it 'is invalid invoice' do
      # With a data_hash
      invoice = build(:invoice, tax_bps: 1000, line_items: @line_items, data_hash: 'xyz')
      assert_not invoice.valid?

      # With no issue details
      invoice = build(:invoice, tax_bps: 1000, line_items: @line_items, issuer_contact: nil)
      assert_not invoice.save

      # with no client details
      invoice = build(:invoice, tax_bps: 1000, line_items: @line_items, client_contact: nil)
      assert_not invoice.save

      # With no payment_address
      invoice = build(:invoice, tax_bps: 1000, line_items: @line_items, payment_address: nil)
      assert_not invoice.valid?

      # With no network
      invoice = build(:invoice, tax_bps: 1000, line_items: @line_items, network: nil)
      assert_not invoice.valid?

      # With no number
      invoice = build(:invoice, tax_bps: 1000, line_items: @line_items, number: nil)
      assert_not invoice.valid?

      # With no token
      invoice = build(:invoice, tax_bps: 1000, line_items: @line_items, token: nil)
      assert_not invoice.valid?
    end
  end

  describe 'encrypted invoice' do
    it 'is valid' do
      invoice = build(:invoice, :encrypted)
      assert invoice.valid?
    end

    it 'is invalid' do
      # Without data_hash
      invoice = build(:invoice, :encrypted, data_hash: nil)
      assert_not invoice.valid?

      # With number
      invoice = build(:invoice, :encrypted, number: '001')
      assert_not invoice.valid?

      # With description
      invoice = build(:invoice, :encrypted, description: 'a description')
      assert_not invoice.valid?

      # With payment_address
      invoice = build(:invoice, :encrypted, payment_address: '0xBeE21365A462b8df12CFE9ab7C40f1BB5f5ED495')
      assert_not invoice.valid?

      # With issuer_contact
      invoice = build(:invoice, :encrypted, issuer_contact_attributes: { business_name: 'a business' })
      assert_not invoice.save

      # With client_contact
      invoice = build(:invoice, :encrypted, client_contact_attributes: { business_name: 'a client' })
      assert_not invoice.save

      # With line_items
      invoice = build(:invoice, :encrypted, :with_line_item)
      assert_not invoice.save
    end
  end
end

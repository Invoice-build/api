# frozen_string_literal: true

# == Schema Information
#
# Table name: line_items
#
#  id               :uuid             not null, primary key
#  invoice_id       :uuid
#  description      :text
#  quantity         :float
#  quantity_type    :text
#  unit_price_units :bigint           not null
#  amount_units     :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  describe 'simple numbers' do
    def setup
      @line_item = build(:line_item, quantity: 2, unit_price: 220)
      @invoice = create(:invoice, line_items: [@line_item])
    end

    it 'has correct unit_price_units' do
      assert_equal @line_item.unit_price_units, 220e6
    end

    it 'has correct amount and amount_units' do
      assert_equal @line_item.amount, 440
      assert_equal @line_item.amount_units, 440e6
    end
  end

  describe 'lots of decimals' do
    # Limit is 6 decimals for now, validated on the frontend too. Anything after is cut off.
    def setup
      @line_item = build(:line_item, quantity: 1, unit_price: 1.123456789)
      @invoice = create(:invoice, line_items: [@line_item])
    end

    it 'has correct unit_price_units' do
      assert_equal 1.123456e6, @line_item.unit_price_units
    end

    it 'has correct amount and amount_units' do
      assert_equal @line_item.amount, 1.123456
      assert_equal @line_item.amount_units, 1.123456e6
    end
  end
end

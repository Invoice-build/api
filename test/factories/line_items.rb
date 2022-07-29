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
FactoryBot.define do
  factory :line_item do
    description { 'Item details' }
    quantity { 1 }
    quantity_type { 'month' }
    unit_price { 100 }
  end
end

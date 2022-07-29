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
class LineItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :quantity, :quantity_type, :unit_price
end

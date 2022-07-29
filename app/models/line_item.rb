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
class LineItem < ApplicationRecord
  # CONCERNS
  include Tokenable

  tokenize :unit_price_units, as: :unit_price
  tokenize :amount_units, as: :amount, validate: false

  # ASSOCIATIONS
  belongs_to :invoice

  # CALLBACKS
  before_save :set_amount

  # VALIDATIONS
  validates :description, :quantity, :quantity_type, presence: true

  private

  def set_amount
    self.amount = unit_price * quantity
  end
end

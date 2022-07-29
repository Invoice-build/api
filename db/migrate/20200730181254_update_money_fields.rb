class UpdateMoneyFields < ActiveRecord::Migration[6.0]
  def up
    rename_column :line_items, :unit_price, :unit_price_units
    rename_column :line_items, :amount, :amount_units

    change_column :line_items, :unit_price_units, :integer, limit: 8, null: false
    change_column :line_items, :amount_units, :integer, limit: 8, null: false
  end

  def down
    change_column :line_items, :unit_price_units, :float
    change_column :line_items, :amount_units, :float

    rename_column :line_items, :unit_price_units, :unit_price
    rename_column :line_items, :amount_units, :amount
  end
end

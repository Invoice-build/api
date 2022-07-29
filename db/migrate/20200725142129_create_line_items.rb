class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items, id: :uuid do |t|
      t.uuid :invoice_id
      t.text :description
      t.float :quantity
      t.text :quantity_type
      t.float :unit_price
      t.float :amount

      t.timestamps
    end
  end
end

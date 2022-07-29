class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses, id: :uuid do |t|
      t.uuid :addressable_id
      t.text :addressable_type
      t.text :address_1
      t.text :address_2
      t.text :district
      t.text :city
      t.text :postcode
      t.text :country

      t.timestamps
    end
    add_index :addresses, :addressable_id
  end
end

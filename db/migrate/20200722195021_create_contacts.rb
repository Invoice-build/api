class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts, id: :uuid do |t|
      t.text :business_name
      t.text :contact_name
      t.text :business_reg_number
      t.text :tax_number
      t.text :email
      t.text :phone

      t.timestamps
    end
  end
end

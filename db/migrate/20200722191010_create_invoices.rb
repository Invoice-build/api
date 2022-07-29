class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices, id: :uuid do |t|
      t.text :number
      t.text :token_id
      t.timestamp :due_at
      t.text :description
      t.integer :tax_bps, default: 0
      t.text :payment_address
      t.text :issuer_contact_id
      t.text :client_contact_id
      t.text :account_id

      t.timestamps
    end
    add_index :invoices, :account_id
    add_index :invoices, :issuer_contact_id
    add_index :invoices, :client_contact_id
    add_index :invoices, :token_id
  end
end

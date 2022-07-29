class AddPasswordToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :password_digest, :text
  end
end

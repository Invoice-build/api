class AddDataHashToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :data_hash, :text
  end
end

class AddNetworkToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :network, :text, default: 'mainnet'
  end
end

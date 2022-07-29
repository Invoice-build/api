class AddDataToEthTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :eth_transactions, :data, :jsonb
    add_column :eth_transactions, :input_data, :jsonb
  end
end

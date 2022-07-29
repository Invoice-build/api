class AddValidToEthTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :eth_transactions, :transactable_valid, :boolean, default: false
  end
end

class AddNetworkToEthTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :eth_transactions, :network, :text, default: 'mainnet'
  end
end

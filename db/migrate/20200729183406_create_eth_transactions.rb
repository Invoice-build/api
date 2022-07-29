class CreateEthTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :eth_transactions, id: :uuid do |t|
      t.text :tx_hash
      t.text :reference
      t.datetime :confirmed_at
      t.datetime :failed_at
      t.uuid :transactable_id
      t.text :transactable_type

      t.timestamps
    end
    add_index :eth_transactions, :reference
    add_index :eth_transactions, :transactable_id
  end
end

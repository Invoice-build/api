class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens, id: :uuid do |t|
      t.text :code
      t.text :address
      t.text :network, default: 'mainnet'
      t.integer :decimals, default: 18

      t.timestamps
    end
  end
end

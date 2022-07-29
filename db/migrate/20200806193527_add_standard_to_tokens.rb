class AddStandardToTokens < ActiveRecord::Migration[6.0]
  def change
    add_column :tokens, :standard, :text, default: 'erc20'
  end
end

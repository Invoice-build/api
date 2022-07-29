# frozen_string_literal: true

class EthTransaction::OnCreatedJob < ApplicationJob
  def perform(eth_transaction_id)
    eth_transaction = EthTransaction.find(eth_transaction_id)
    Notify.slack("*Event*: Payment made\n*ID*: #{eth_transaction_id}\n*Hash*: #{eth_transaction.tx_hash}")
  end
end

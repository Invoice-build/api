# frozen_string_literal: true

class EthTransactionListener
  def eth_transaction_created(eth_transaction_id:, **_payload)
    EthTransaction::OnCreatedJob.perform_later(eth_transaction_id)
  end
end

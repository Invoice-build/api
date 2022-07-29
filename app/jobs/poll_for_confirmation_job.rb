# frozen_string_literal: true

class PollForConfirmationJob < ApplicationJob
  retry_on ActiveRecord::RecordNotFound
  queue_as :critical

  attr_reader :resource

  def perform(id, resource_model: EthTransaction)
    @resource = resource_model.find(id)
    return if resource.confirmed_at.present? || resource.failed_at.present?

    if (confirmations = etherscan_service.get_confirmations(resource.tx_hash))
      puts "#{confirmations} confirmations for #{resource.tx_hash}"
      confirmation_handler(confirmations)
    elsif resource.updated_at > 5.minutes.ago
      puts "Tx #{resource.tx_hash} probably not available via Etherscan API yet"
      PollForConfirmationJob.set(wait: 10.seconds).perform_later(resource.id)
      nil
    else
      puts "Tx #{resource.tx_hash} failed!"
      resource.update!(failed_at: Time.now)
      Ethereum::Transaction::Worker.perform_later('fetch_data', eth_transaction_id: resource.id)
    end
  end

  def confirmation_handler(confirmations)
    if confirmations >= 3
      confirmed_at = etherscan_service.get_confirmed_at(resource.tx_hash)
      resource.update!(confirmed_at: confirmed_at)
      Ethereum::Transaction::Worker.perform_later('fetch_data', eth_transaction_id: resource.id)
    else
      PollForConfirmationJob.set(wait: 10.seconds).perform_later(resource.id)
      nil
    end
  end

  private

  def etherscan_service
    @etherscan_service ||= Etherscan::Service.new(network: resource.network)
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: eth_transactions
#
#  id                 :uuid             not null, primary key
#  tx_hash            :text
#  reference          :text
#  confirmed_at       :datetime
#  failed_at          :datetime
#  transactable_id    :uuid
#  transactable_type  :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  network            :text             default("mainnet")
#  data               :jsonb
#  input_data         :jsonb
#  transactable_valid :boolean          default(FALSE)
#
FactoryBot.define do
  factory :eth_transaction do
    tx_hash { '0x12345' }
    reference { 'payment' }
    confirmed_at { nil }
    failed_at { nil }
    data { JSON.parse(read_fixture_file('eth_tx_data.json')) }
    transactable_type { 'Invoice' }

    trait :confirmed do
      confirmed_at { Time.now }
      transactable_valid { true }
    end

    trait :erc20 do
      data { JSON.parse(read_fixture_file('erc20_tx_data.json')) }
      input_data { JSON.parse(read_fixture_file('erc20_tx_input_data.json')) }
    end
  end
end

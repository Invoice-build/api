# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id         :uuid             not null, primary key
#  code       :text
#  address    :text
#  network    :text             default("mainnet")
#  decimals   :integer          default(18)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  standard   :text             default("erc20")
#
FactoryBot.define do
  factory :token do
    code { 'ETH' }
    address { '0x0000000000000000000000000000000000000000' }
    decimals { 18 }
    network { 'mainnet' }
    standard { 'native' }

    trait :erc20 do
      code { 'DAI' }
      address { '0x6b175474e89094c44da98b954eedeac495271d0f' }
    end
  end
end

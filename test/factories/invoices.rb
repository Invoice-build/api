# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id                :uuid             not null, primary key
#  number            :text
#  token_id          :text
#  due_at            :datetime
#  description       :text
#  tax_bps           :integer          default(0)
#  payment_address   :text
#  issuer_contact_id :text
#  client_contact_id :text
#  account_id        :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  network           :text             default("mainnet")
#  password_digest   :text
#
FactoryBot.define do
  factory :invoice do
    number { '001' }
    due_at { Time.now + 30.days }
    description { nil }
    tax_bps { 0 }
    payment_address { '0xBeE21365A462b8df12CFE9ab7C40f1BB5f5ED495' }

    association :token, factory: :token
    association :issuer_contact, factory: :contact
    association :client_contact, factory: :contact

    trait :with_line_item do
      after :build do |invoice|
        invoice.line_items << build_list(:line_item, 1, invoice: nil)
      end
    end

    trait :erc20 do
      association :token, :erc20
    end

    trait :encrypted do
      number { nil }
      due_at { nil }
      description { nil }
      tax_bps { 0 }
      payment_address { nil }
      issuer_contact { nil }
      client_contact { nil }
      data_hash { 'xyz' }
    end
  end
end

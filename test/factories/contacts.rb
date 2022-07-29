# frozen_string_literal: true

# == Schema Information
#
# Table name: contacts
#
#  id                  :uuid             not null, primary key
#  business_name       :text
#  contact_name        :text
#  business_reg_number :text
#  tax_number          :text
#  email               :text
#  phone               :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :contact do
    business_name { 'Remotely Digital Ltd' }
    contact_name { 'Gareth Fuller' }
    business_reg_number { '123456' }
    tax_number { '123456' }
    email { 'gareth@remotely.digital' }
    phone { '+447701072712' }

    # association :address, factory: :address
  end
end

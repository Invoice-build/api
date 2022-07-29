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
class ContactSerializer < ActiveModel::Serializer
  attributes :id, :business_name, :contact_name, :business_reg_number, :tax_number,
             :email, :phone, :address_attributes

  def address_attributes
    serialize(object.address)
  end

  private

  def serialize(resource)
    ActiveModelSerializers::SerializableResource.new(resource).as_json
  end
end

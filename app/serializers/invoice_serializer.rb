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
class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :number, :due_at, :description, :tax_bps, :payment_address,
             :issuer_contact_attributes, :client_contact_attributes, :token_id,
             :line_items_attributes, :created_at, :total, :network, :paid, :paid_amount,
             :data_hash

  belongs_to :token

  def paid
    object.paid?
  end

  def due_at
    object.due_at&.strftime('%Y-%m-%d')
  end

  def issuer_contact_attributes
    serialize(object.issuer_contact)
  end

  def client_contact_attributes
    serialize(object.client_contact)
  end

  def line_items_attributes
    serialize(object.line_items)
  end

  private

  def serialize(resource)
    ActiveModelSerializers::SerializableResource.new(resource).as_json
  end
end

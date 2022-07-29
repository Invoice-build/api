# frozen_string_literal: true

require 'test_helper'

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @token = create(:token)
  end

  describe '#store' do
    it 'creates a new invoice' do
      invoice_params = attributes_for(:invoice, token_id: @token.id).merge(
        issuer_contact_attributes: attributes_for(:contact, address_attributes: attributes_for(:address)),
        client_contact_attributes: attributes_for(:contact, address_attributes: attributes_for(:address)),
        line_items_attributes: [
          attributes_for(:line_item),
          attributes_for(:line_item),
          attributes_for(:line_item)
        ]
      )

      assert_difference -> { Contact.count } => 2, -> { LineItem.count } => 3 do
        post invoices_url, params: { invoice: invoice_params }
        assert_response :success
      end
    end

    # NOTE: Updating not allowed yet, need to add authentication first
    # describe 'updates' do
    #   it 'updates existing invoice' do
    #     invoice = create(:invoice,
    #       number: '001',
    #       token_id: @token.id,
    #       issuer_contact_attributes: attributes_for(:contact, business_name: 'Company A'),
    #       client_contact_attributes: attributes_for(:contact, business_name: 'Company C'),
    #       line_items_attributes: [
    #         attributes_for(:line_item, description: 'Item A'),
    #         attributes_for(:line_item, description: 'Item B'),
    #         attributes_for(:line_item, description: 'Item C')
    #       ]
    #     )

    #     assert_changes -> { invoice.reload; invoice.number } do
    #       post store_invoices_url(invoice.id), params: { invoice: { number: '002' } }
    #       assert_response :success
    #     end
    #   end

    #   it 'deletes line_items' do
    #     invoice = create(:invoice,
    #       token_id: @token.id,
    #       issuer_contact_attributes: attributes_for(:contact, business_name: 'Company A'),
    #       client_contact_attributes: attributes_for(:contact, business_name: 'Company C'),
    #       line_items_attributes: [
    #         attributes_for(:line_item, description: 'Item A'),
    #         attributes_for(:line_item, description: 'Item B'),
    #         attributes_for(:line_item, description: 'Item C')
    #       ]
    #     )

    #     assert_difference -> { invoice.line_items.count } => -2 do
    #       post store_invoices_url(invoice.id), params: { invoice: { line_items_attributes: [
    #         invoice.line_items[0].attributes.merge(_destroy: '1'),
    #         invoice.line_items[1].attributes.merge(_destroy: '1'),
    #         invoice.line_items[2].attributes.as_json
    #       ]}}
    #       assert_response :success
    #     end
    #   end

    #   it 'updates contacts' do
    #     invoice = create(:invoice,
    #       token_id: @token.id,
    #       issuer_contact_attributes: attributes_for(:contact, business_name: 'Company A'),
    #       client_contact_attributes: attributes_for(:contact, business_name: 'Company B'),
    #       line_items_attributes: [
    #         attributes_for(:line_item, description: 'Item A'),
    #         attributes_for(:line_item, description: 'Item B'),
    #         attributes_for(:line_item, description: 'Item C')
    #       ]
    #     )

    #     assert_changes -> { invoice.reload; invoice.issuer_contact.business_name }, from: 'Company A', to: 'Company C'  do
    #       post store_invoices_url(invoice.id), params: { invoice: {
    #         issuer_contact_attributes: { business_name: 'Company C' }
    #       }}
    #       assert_response :success
    #     end
    #   end
    # end
  end
end

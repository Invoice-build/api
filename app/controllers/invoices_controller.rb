# frozen_string_literal: true

class InvoicesController < ApplicationController
  include InvoiceAuthorization

  # GET /invoices/:id
  def show
    invoice = Invoice.find(params[:id])

    if authenticated_invoice?(invoice)
      render json: invoice, status: :ok
    else
      head :unauthorized
    end
  end

  # GET /invoices/:id/encrypted
  def encrypted
    invoice = Invoice.find(params[:id])

    if invoice.encrypted?
      render json: invoice, status: :ok
    else
      head :unprocessable_entity
    end
  end

  # POST /invoices/:id/auth
  def auth
    invoice = Invoice.find(params[:id])

    if invoice.authenticate(params[:password])
      render json: { invoice: serialize(invoice), jwt: invoice_session_token(invoice) }, status: :ok
    else
      head :unprocessable_entity
    end
  end

  # POST /invoices
  def create
    invoice = Invoice.new(invoice_params)

    if invoice.save
      EventBus.publish(:invoice_created, invoice_id: invoice.id)
      render json: invoice, status: :ok
    else
      render json: invoice.errors, status: :unprocessable_entity
    end
  end

  private

  def invoice_params
    contact_attributes = [
      :id, :business_name, :contact_name, :business_reg_number, :tax_number, :email, :phone,
      { address_attributes: %i[id address_1 address_2 district city postcode country] }
    ]
    line_items_attributes = %i[id description quantity quantity_type unit_price _destroy]

    params.require(:invoice).permit(
      :number, :due_at, :description, :tax_bps, :payment_address, :token_id, :network, :password, :data_hash,
      issuer_contact_attributes: contact_attributes,
      client_contact_attributes: contact_attributes,
      line_items_attributes: line_items_attributes
    )
  end
end

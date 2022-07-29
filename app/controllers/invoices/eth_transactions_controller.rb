# frozen_string_literal: true

module Invoices
  class EthTransactionsController < ApplicationController
    # GET /invoices/:invoice_id/eth_transactions/:id
    def show
      eth_transaction = invoice.eth_transactions.find(params[:id])
      render json: eth_transaction, status: :ok
    end

    # GET /invoices/:invoice_id/eth_transactions
    def index
      render json: invoice.eth_transactions, status: :ok
    end

    # POST /invoices/:invoice_id/eth_transactions
    def create
      eth_transaction = invoice.eth_transactions.build(eth_transaction_params)

      if eth_transaction.save
        EventBus.publish(:eth_transaction_created, eth_transaction_id: eth_transaction.id)
        render json: eth_transaction, status: :created
      else
        render json: eth_transaction.errors, status: :unprocessable_entity
      end
    end

    private

    def eth_transaction_params
      params.require(:eth_transaction).permit(:tx_hash, :reference, :network)
    end

    def invoice
      @invoice ||= Invoice.find(params[:invoice_id])
    end
  end
end

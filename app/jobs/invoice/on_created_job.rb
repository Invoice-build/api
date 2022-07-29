# frozen_string_literal: true

class Invoice::OnCreatedJob < ApplicationJob
  def perform(invoice_id)
    Notify.slack("*Event*: New Invoice\n*ID*: #{invoice_id}")
  end
end

# frozen_string_literal: true

class InvoiceListener
  def invoice_created(invoice_id:, **_payload)
    Invoice::OnCreatedJob.perform_later(invoice_id)
  end
end

# frozen_string_literal: true

module InvoiceAuthorization
  extend ActiveSupport::Concern

  included do
    def authenticated_invoice?(invoice)
      return true unless invoice.password_digest

      password_has_been_provided?
    end

    def invoice_session_token(invoice)
      expires = Time.now.to_i + 30.days.to_i
      JWT.encode({ invoice_id: invoice.id, exp: expires }, Creds.fetch(:jwt_secret), 'HS256')
    end

    private

    def password_has_been_provided?
      return false if decoded_invoice_token.empty?

      Invoice.find_by(id: decoded_invoice_token[0]['invoice_id']) || false
    end

    def decoded_invoice_token
      if (token = request.headers['Invoice-Authorization'])
        begin
          JWT.decode(token, Creds.fetch(:jwt_secret), true, { algorithm: 'HS256' })
        rescue JWT::ExpiredSignature
          []
        rescue JWT::DecodeError
          []
        end
      else
        []
      end
    end
  end
end

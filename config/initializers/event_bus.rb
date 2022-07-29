unless Rails.env.test?
  Rails.application.config.to_prepare do
    EventBus.clear

    EventBus.subscribe(InvoiceListener.new)
    EventBus.subscribe(EthTransactionListener.new)
  end
end

EventBus.on_error do |_listener, payload|
  raise payload[:error]
end

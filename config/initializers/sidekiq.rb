Sidekiq.configure_client do |config|
  config.redis = {
    url: "#{ENV['REDIS_URL']}",
    namespace: 'invoice_build'
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: "#{ENV['REDIS_URL']}",
    namespace: 'invoice_build'
  }
end

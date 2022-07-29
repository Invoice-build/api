# frozen_string_literal: true

class Notify
  attr_reader :notifier

  def initialize
    webhook_url = Creds.fetch(:slack, :webhooks, :incoming_url)
    @notifier = Slack::Notifier.new(webhook_url, channel: '#notifications', username: 'invoice.build')
  end

  def self.slack(message)
    new.slack(message)
  end

  def slack(message)
    notifier.ping(message)
  end
end

class SlackNotificationService
  def initialize(**params)
    @params = ActionController::Parameters.new(params)
  end

  def send_notification(channel:, title:, body:)
    notifier = Slack::Notifier.new 'https://hooks.slack.com/services/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', channel: channel, username: title

    notifier.ping body, channel: channel
  end
end

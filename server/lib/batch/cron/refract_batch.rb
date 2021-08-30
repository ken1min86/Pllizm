class Batch::TestBatch
  def self.testBatch
    puts '--- Batch::TestBatch.testBatch ---'

    sns = SlackNotificationService.new
    channel = "#channel"
    title = "test"
    body = "test"
    sns.send_notification(channel: channel, title: title, body: body)
  end
end

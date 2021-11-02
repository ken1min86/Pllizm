class Batch::Cron::RefractBatch
  def self.weekly_set_refract
    users = User.all
    users.each do |user|
      refract_last_week = CurrentUserRefract.find_by(user_id: user.id, performed_refract: false)
      if refract_last_week.present?
        refract_last_week.destroy
      end
      refract_this_week = CurrentUserRefract.create(user_id: user.id, performed_refract: false)

      refract_candidates_of_like, refract_candidates_of_reply = Post.get_not_formatted_refract_candidates(user)
      hashed_refract_candidates = refract_candidates_of_like.concat(refract_candidates_of_reply)

      if !user.has_right_to_use_pllizm
        refract_this_week.destroy
      elsif hashed_refract_candidates.empty?
        refract_this_week.destroy
      end
    end
    webhook_url = ENV['WEBHOOK_URL'].dup.force_encoding("UTF-8")
    channel = ENV['CHANNEL'].dup.force_encoding("UTF-8")
    notifier = Slack::Notifier.new(
      webhook_url,
      channel: '#' + channel
    )
    notifier.ping("[#{Rails.env}]リフラクトセットのバッチ処理が完了しました")
  end
end

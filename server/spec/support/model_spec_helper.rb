module ModelSpecHelper
  def get_non_existemt_user_id
    non_existemt_userid = SecureRandom.alphanumeric(15)
    while User.find_by(userid: non_existemt_userid)
      non_existemt_userid = SecureRandom.alphanumeric(15)
    end
    non_existemt_userid
  end

  def create_mutual_follow_user(user)
    mutual_follow_user = FactoryBot.create(:user, userid: get_non_existemt_user_id)
    Follower.create(followed_by: user.id, follow_to: mutual_follow_user.id)
    Follower.create(followed_by: mutual_follow_user.id, follow_to: user.id)
    mutual_follow_user
  end
end

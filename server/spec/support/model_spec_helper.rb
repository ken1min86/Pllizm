module ModelSpecHelper
  def get_non_existent_user_id
    non_existent_userid = SecureRandom.alphanumeric(15)
    while User.find_by(userid: non_existent_userid)
      non_existent_userid = SecureRandom.alphanumeric(15)
    end
    non_existent_userid
  end

  def get_non_existent_post_id
    non_existent_post_id = SecureRandom.alphanumeric(20)
    while Post.find_by(id: non_existent_post_id)
      non_existent_post_id = SecureRandom.alphanumeric(20)
    end
    non_existent_post_id
  end
end

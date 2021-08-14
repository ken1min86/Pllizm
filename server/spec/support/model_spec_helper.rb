module ModelSpecHelper
  def get_non_existemt_user_id
    non_existemt_userid = SecureRandom.alphanumeric(15)
    while User.find_by(userid: non_existemt_userid)
      non_existemt_userid = SecureRandom.alphanumeric(15)
    end
    non_existemt_userid
  end
end

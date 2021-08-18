module RequestSpecHelper
  def sign_up(account)
    post v1_user_registration_path, params: {
      password: 'password123',
      password_confirmation: 'password123',
      email: "#{account}@gmail.com",
    }
  end

  def login(account)
    post v1_user_session_path, params: {
      email: "#{account}@gmail.com",
      password: 'password123',
    }
  end

  def create_header_from_response(response)
    {
      uid: response.header['uid'],
      'access-token': response.header['access-token'],
      client: response.header['client'],
    }
  end

  def get_current_user_by_response(response)
    User.find_by(uid: response.header['uid'])
  end

  def get_non_existent_user_id
    non_existent_userid = SecureRandom.alphanumeric(15)
    while User.find_by(userid: non_existent_userid)
      non_existent_userid = SecureRandom.alphanumeric(15)
    end
    non_existent_userid
  end

  def create_mutual_follow_user(user)
    mutual_follow_user = FactoryBot.create(:user, userid: get_non_existent_user_id)
    Follower.create(followed_by: user.id, follow_to: mutual_follow_user.id)
    Follower.create(followed_by: mutual_follow_user.id, follow_to: user.id)
    mutual_follow_user
  end

  def create_follow_requested_user_by_argument_user(user)
    follow_requested_user = FactoryBot.create(:user)
    user.follow_requests.create(request_to: follow_requested_user.id)
    follow_requested_user
  end

  def create_user_to_request_follow_to_argument_user(user)
    follow_request_user = FactoryBot.create(:user)
    follow_request_user.follow_requests.create(request_to: user.id)
    follow_request_user
  end
end

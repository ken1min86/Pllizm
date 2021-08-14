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

  def logout(response)
    delete destroy_v1_user_session_path params: {
      uid: response.header['uid'],
      'access-token': response.header['access-token'],
      client: response.header['client'],
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

  def sign_up_and_create_a_new_post
    sign_up(Faker::Name.first_name)
    headers = create_header_from_response(response)
    FactoryBot.create_list(:icon, 5)
    post v1_posts_path, params: { content: 'Hello!' }, headers: headers
    request_headers = create_header_from_response(response)
    created_post_id = Post.find_by(user_id: get_current_user_by_response(response).id).id
    { post_id: created_post_id, request_headers: request_headers }
  end

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

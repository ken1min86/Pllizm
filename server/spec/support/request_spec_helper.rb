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

  def get_not_existent_userid
    not_existent_userid = SecureRandom.alphanumeric(15)
    while User.find_by(userid: not_existent_userid)
      not_existent_userid = SecureRandom.alphanumeric(15)
    end
    not_existent_userid
  end

  def get_non_existent_post_id
    non_existent_post_id = SecureRandom.alphanumeric(20)
    while Post.find_by(id: non_existent_post_id)
      non_existent_post_id = SecureRandom.alphanumeric(20)
    end
    non_existent_post_id
  end

  def create_follower(user, follower_username: Faker::Name.name)
    follower = create(:user, userid: get_non_existent_user_id, username: follower_username)
    Follower.create(followed_by: user.id, follow_to: follower.id)
    Follower.create(followed_by: follower.id, follow_to: user.id)
    follower
  end

  def create_follow_requested_user_by_argument_user(user, follower_username: Faker::Name.name)
    follow_requested_user = create(:user, username: follower_username)
    user.follow_requests.create(request_to: follow_requested_user.id)
    follow_requested_user
  end

  def create_user_to_request_follow_to_argument_user(user, follower_username: Faker::Name.name)
    follow_request_user = create(:user, username: follower_username)
    follow_request_user.follow_requests.create(request_to: user.id)
    follow_request_user
  end

  def create_reply_to_prams_post(reply_user, replied_post)
    headers = reply_user.create_new_auth_token
    params = {
      content: 'Hello!',
      image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.png"), "image/png"),
      is_locked: false,
    }
    post v1_post_replies_path(replied_post.id), params: params, headers: headers
    expect(response).to have_http_status(200)
    response_body = JSON.parse(response.body, symbolize_names: true)
    reply         = Post.find(response_body[:id])
    reply
  end
end

def format_to_rfc3339(formatted_time)
  formatted_time.to_datetime.new_offset('+0000').rfc3339
end

def get_right_to_use_plizm(user)
  create_follower(user)
  create_follower(user)
  expect(user.has_right_to_use_plizm).to eq(true)
end

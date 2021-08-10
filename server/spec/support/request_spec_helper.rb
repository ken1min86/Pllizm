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

  def sign_up_and_create_a_new_post
    sign_up(Faker::Name.first_name)
    headers = create_header_from_response(response)
    FactoryBot.create_list(:icon, 5)
    post v1_posts_path, params: {content: 'Hello!'}, headers: headers
    request_headers = create_header_from_response(response)
    created_post_id = Post.find_by(user_id: get_current_user_by_response(response).id).id
    return {post_id: created_post_id, request_headers: request_headers}
  end
end

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
end

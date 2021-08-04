module RequestSpecHelper
  def sign_up
    post v1_user_registration_path, params: {
      password: 'password123',
      password_confirmation: 'password123',
      email: 'test@gmail.com',
    }
  end

  def login
    post v1_user_session_path, params: {
      email: 'test@gmail.com',
      password: 'password123',
    }
  end
end

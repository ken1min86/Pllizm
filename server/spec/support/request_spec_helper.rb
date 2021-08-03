module RequestSpecHelper
  def sign_up
    post v1_user_registration_path, params: {
      password: 'password123',
      password_confirmation: 'password123',
      email: 'test@gmail.com',
    }
  end
end

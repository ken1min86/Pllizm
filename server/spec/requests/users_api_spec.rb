require 'rails_helper'

RSpec.describe "UsersApi", type: :request do
  describe "POST v1_user_registration_api" do
    it 'returns 200 with password, password_confirmation and valid email and password equals to password_confirmation' do
      expect do
        sign_up
      end.to change(User.all, :count).by(1)

      signupped_user = User.find_by(email: 'test@gmail.com')

      expect(signupped_user.email).to eq 'test@gmail.com'
      expect(signupped_user.uid).to   eq 'test@gmail.com'
      expect(signupped_user.name).to  eq 'test'
      expect(response).to have_http_status(200)
    end

    it 'returns 422 without password' do
      post v1_user_registration_path, params: {
        password_confirmation: 'password123',
        email: 'tester@gmail.com',
      }
      expect(response).to have_http_status(422)
    end

    it 'returns 404 without password_confirmation' do
      post v1_user_registration_path, params: {
        password: 'password123',
        email: 'tester@gmail.com',
      }
      expect(response).to have_http_status(422)
    end

    it 'returns 422 without email' do
      post v1_user_registration_path, params: {
        password: 'password123',
        password_confirmation: 'password123',
      }
      expect(response).to have_http_status(422)
    end

    it "returns 422 when password doesn't equal to password_confirmation" do
      post v1_user_registration_path, params: {
        password: 'password123',
        password_confirmation: 'password1234',
        email: 'tester@gmail.com',
      }
      expect(response).to have_http_status(422)
    end

    it 'returns 422 when email is invalid' do
      post v1_user_registration_path, params: {
        password: 'password123',
        password_confirmation: 'password123',
        email: 'tester.gmail.com',
      }
      expect(response).to have_http_status(422)
    end
  end

  describe "POST /v1/auth/sign_in_api" do

  end
end

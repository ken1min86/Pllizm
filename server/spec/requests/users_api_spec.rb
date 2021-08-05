require 'rails_helper'

RSpec.describe "UsersApi", type: :request do
  describe "POST v1_user_registration_api" do
    it 'returns 200 with password, password_confirmation and valid email and password equals to password_confirmation' do
      expect do
        sign_up('test')
      end.to change(User.all, :count).by(1)

      sign_upped_user = User.find_by(email: 'test@gmail.com')
      expect(sign_upped_user.userid.length).to eq 15
      expect(sign_upped_user.username).to      eq 'test'
      expect(sign_upped_user.email).to         eq 'test@gmail.com'
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

    it 'returns 200 and is set different userid from another user' do
      sign_up('test1')
      sign_up('test2')
      test1_userid = User.find_by(email: 'test1@gmail.com')
      test2_userid = User.find_by(email: 'test2@gmail.com')
      expect(response).to have_http_status(200)
      expect(test1_userid).not_to eq(test2_userid)
    end
  end

  describe "POST v1_user_session_api" do
    before do
      sign_up('test')
    end

    it 'returns 200 with correct email and password' do
      post v1_user_session_path, params: {
        email: 'test@gmail.com',
        password: 'password123',
      }
      expect(response).to have_http_status(200)
    end

    it 'returns 401 witout email' do
      post v1_user_session_path, params: {
        password: 'password123',
      }
      expect(response).to have_http_status(401)
    end

    it 'returns 401 witout password' do
      post v1_user_session_path, params: {
        email: 'test@gmail.com',
      }
      expect(response).to have_http_status(401)
    end

    it 'returns 401 with incorrect email' do
      post v1_user_session_path, params: {
        email: 'notregisteredmail@gmail.com',
        password: 'password123',
      }
      expect(response).to have_http_status(401)
    end

    it 'returns 401 with correct email and incorrect password' do
      post v1_user_session_path, params: {
        email: 'test@gmail.com',
        password: 'password456',
      }
      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE destroy_v1_user_session" do
    it 'returns 200 when signout' do
      sign_up('test')
      login('test')
      delete destroy_v1_user_session_path params: {
        uid: response.header['uid'],
        'access-token': response.header['access-token'],
        client: response.header['client'],
      }
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE v1_user_registration" do
    it 'returns 200 when signout' do
      sign_up('test')
      login('test')
      count = User.all.count
      expect(User.where(email: 'test@gmail.com').count).to eq 1

      delete v1_user_registration_path params: {
        uid: response.header['uid'],
        'access-token': response.header['access-token'],
        client: response.header['client'],
      }
      expect(User.where(email: 'test@gmail.com').count).to eq 0
      expect(User.all.count).to eq (count - 1)
      expect(response).to have_http_status(200)
    end
  end
end

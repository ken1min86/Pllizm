require 'rails_helper'

RSpec.describe "UsersApi", type: :request do
  describe "POST /v1/auth - v1/auth/registrations#create - Signup" do
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

  describe "POST /v1/auth/sign_in - devise_token_auth/sessions#create - Login" do
    before do
      sign_up('test')
    end

    it 'returns 200 with correct email and password / Login' do
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

  describe "DELETE /v1/auth/sign_out - devise_token_auth/sessions#destroy - Logout" do
    it 'returns 200' do
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

  describe "DELETE /v1/auth - v1/auth/registrations#destroy - Delete account" do
    it 'deletes account and returns 200' do
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

  describe "PUT /v1/auth/password - devise_token_auth/passwords#update - Change password" do
    it 'changes password and returns 200' do
      sign_up('test')
      headers = create_header_from_response(response)
      params = {
        password: 'new_password',
        password_confirmation: 'new_password',
      }
      put v1_user_password_path, params: params, headers: headers
      expect(response).to have_http_status(200)

      post v1_user_session_path, params: {
        email: 'test@gmail.com',
        password: 'new_password',
      }
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /v1/auth - v1/auth/registrations#update - Change users info" do
    context "when try to change userid" do
      before do
        sign_up('test')
        @headers = create_header_from_response(response)
      end

      it "doesn't change userid and returns 422 when userid has 3 characters" do
        put v1_user_registration_path, params: { userid: 'a' * 3 }, headers: @headers
        expect(response).to have_http_status(422)
      end

      it 'changes userid and returns 200 when userid has 4 characters' do
        put v1_user_registration_path, params: { userid: 'a' * 4 }, headers: @headers
        expect(response).to have_http_status(200)
        expect(User.find_by(email: 'test@gmail.com').userid).to eq('a' * 4)
      end

      it 'changes userid and returns 200 when userid has 15 characters' do
        put v1_user_registration_path, params: { userid: 'a' * 15 }, headers: @headers
        expect(response).to have_http_status(200)
        expect(User.find_by(email: 'test@gmail.com').userid).to eq('a' * 15)
      end

      it "doesn't change userid and returns 422 when userid has 16 characters" do
        put v1_user_registration_path, params: { userid: 'a' * 16 }, headers: @headers
        expect(response).to have_http_status(422)
      end
    end

    context "when try to change email" do
      it 'changes email and returns 200' do
        sign_up('test')
        headers = create_header_from_response(response)
        put v1_user_registration_path, params: { email: 'new_email@gmail.com' }, headers: headers
        expect(response).to have_http_status(200)
        expect(User.find_by(email: 'new_email@gmail.com').email).to eq('new_email@gmail.com')
      end
    end

    context "when try to change bio" do
      it 'changes bio and returns 200' do
        sign_up('test')
        headers = create_header_from_response(response)
        put v1_user_registration_path, params: { bio: '猫が好きです。' }, headers: headers
        expect(response).to have_http_status(200)
        expect(User.find_by(email: 'test@gmail.com').bio).to eq('猫が好きです。')
      end
    end
  end
end

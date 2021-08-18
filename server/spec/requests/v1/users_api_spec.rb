require 'rails_helper'

RSpec.describe "V1::UsersApi", type: :request do
  describe "GET /v1/mutual_follow_users - v1/mutual_follow_users#index - Get mutual follow users" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_mutual_follow_users_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user)         { FactoryBot.create(:user) }
      let(:headers)             { client_user.create_new_auth_token }
      let(:mutual_follow_user1) { create_mutual_follow_user(client_user) }
      let(:mutual_follow_user2) { create_mutual_follow_user(client_user) }

      it 'returns 200 and mutual follow users when client has some mutual follow users' do
        # current_userのフォロアーが2人いることを確認
        expect(Follower.where(followed_by: client_user.id, follow_to: mutual_follow_user1.id)).to exist
        expect(Follower.where(followed_by: client_user.id, follow_to: mutual_follow_user2.id)).to exist
        expect(Follower.where(followed_by: client_user.id).length).to eq(2)

        # API
        get v1_mutual_follow_users_path, headers: headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォロアー2人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(2)
        expect(response_body[0].length).to eq(6)
        expect(response_body[1].length).to eq(6)
        expect(response_body[0]).to include(
          id: mutual_follow_user1.id,
          userid: mutual_follow_user1.userid,
          username: mutual_follow_user1.username,
          image: mutual_follow_user1.image.url,
          bio: mutual_follow_user1.bio,
          need_description_about_lock: mutual_follow_user1.need_description_about_lock
        )
        expect(response_body[1]).to include(
          id: mutual_follow_user2.id,
          userid: mutual_follow_user2.userid,
          username: mutual_follow_user2.username,
          image: mutual_follow_user2.image.url,
          bio: mutual_follow_user2.bio,
          need_description_about_lock: mutual_follow_user2.need_description_about_lock
        )
      end

      it 'returns 200 and mutual follow user when client has a mutual follow user' do
        # current_userのフォロアーが1人いることを確認
        expect(Follower.where(followed_by: client_user.id, follow_to: mutual_follow_user1.id)).to exist
        expect(Follower.where(followed_by: client_user.id).length).to eq(1)

        # API
        get v1_mutual_follow_users_path, headers: headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォロアー1人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(1)
        expect(response_body[0].length).to eq(6)
        expect(response_body[0]).to include(
          id: mutual_follow_user1.id,
          userid: mutual_follow_user1.userid,
          username: mutual_follow_user1.username,
          image: mutual_follow_user1.image.url,
          bio: mutual_follow_user1.bio,
          need_description_about_lock: mutual_follow_user1.need_description_about_lock
        )
      end

      it "returns 200 and no users when client has no mutual follow users" do
        expect(Follower.where(followed_by: client_user.id)).not_to exist

        get v1_mutual_follow_users_path, headers: headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(0)
      end
    end
  end

  describe "GET /v1/follow_requested_by_me_users - v1/users#index_of_users_follow_requested_by_me - Get users requested by me" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_follow_requested_by_me_users_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user)            { FactoryBot.create(:user) }
      let(:headers)                { client_user.create_new_auth_token }
      let(:follow_requested_user1) { create_follow_requested_user_by_argument_user(client_user) }
      let(:follow_requested_user2) { create_follow_requested_user_by_argument_user(client_user) }

      it 'returns 200 and follow requested users when client has some follow requested users' do
        # current_userがフォローリクエストしているユーザが2人いることを確認
        expect(FollowRequest.where(requested_by: client_user.id, request_to: follow_requested_user1.id)).to exist
        expect(FollowRequest.where(requested_by: client_user.id, request_to: follow_requested_user2.id)).to exist
        expect(FollowRequest.where(requested_by: client_user.id).length).to eq(2)

        # API
        get v1_follow_requested_by_me_users_path, headers: headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォローリクエストしているユーザ2人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(2)
        expect(response_body[0].length).to eq(6)
        expect(response_body[1].length).to eq(6)
        expect(response_body[0]).to include(
          id: follow_requested_user1.id,
          userid: follow_requested_user1.userid,
          username: follow_requested_user1.username,
          image: follow_requested_user1.image.url,
          bio: follow_requested_user1.bio,
          need_description_about_lock: follow_requested_user1.need_description_about_lock
        )
        expect(response_body[1]).to include(
          id: follow_requested_user2.id,
          userid: follow_requested_user2.userid,
          username: follow_requested_user2.username,
          image: follow_requested_user2.image.url,
          bio: follow_requested_user2.bio,
          need_description_about_lock: follow_requested_user2.need_description_about_lock
        )
      end

      it 'returns 200 and follow requested user when client has a follow requested user' do
        # current_userがフォローリクエストしているユーザが1人いることを確認
        expect(FollowRequest.where(requested_by: client_user.id, request_to: follow_requested_user1.id)).to exist
        expect(FollowRequest.where(requested_by: client_user.id).length).to eq(1)

        # API
        get v1_follow_requested_by_me_users_path, headers: headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォローリクエストしているユーザ1人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(1)
        expect(response_body[0].length).to eq(6)
        expect(response_body[0]).to include(
          id: follow_requested_user1.id,
          userid: follow_requested_user1.userid,
          username: follow_requested_user1.username,
          image: follow_requested_user1.image.url,
          bio: follow_requested_user1.bio,
          need_description_about_lock: follow_requested_user1.need_description_about_lock
        )
      end

      it "returns 200 and no users when client has no follow requested users" do
        expect(FollowRequest.where(requested_by: client_user.id)).not_to exist

        get v1_follow_requested_by_me_users_path, headers: headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(0)
      end
    end
  end

  describe "GET /v1/v1_follow_request_to_me_users - v1/users#index_of_users_follow_request_to_me - Get users requested to me" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_follow_request_to_me_users_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user)                { FactoryBot.create(:user) }
      let(:headers)                    { client_user.create_new_auth_token }
      let(:follow_request_to_me_user1) { create_user_to_request_follow_to_argument_user(client_user) }
      let(:follow_request_to_me_user2) { create_user_to_request_follow_to_argument_user(client_user) }

      it 'returns 200 and follow requested users when client has some follow requested users' do
        # current_userにフォローリクエストしているユーザが2人いることを確認
        expect(FollowRequest.where(requested_by: follow_request_to_me_user1.id, request_to: client_user.id)).to exist
        expect(FollowRequest.where(requested_by: follow_request_to_me_user2.id, request_to: client_user.id)).to exist
        expect(FollowRequest.where(request_to: client_user.id).length).to eq(2)

        # API
        get v1_follow_request_to_me_users_path, headers: headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォローリクエストしているユーザ2人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(2)
        expect(response_body[0].length).to eq(6)
        expect(response_body[1].length).to eq(6)
        expect(response_body[0]).to include(
          id: follow_request_to_me_user1.id,
          userid: follow_request_to_me_user1.userid,
          username: follow_request_to_me_user1.username,
          image: follow_request_to_me_user1.image.url,
          bio: follow_request_to_me_user1.bio,
          need_description_about_lock: follow_request_to_me_user1.need_description_about_lock
        )
        expect(response_body[1]).to include(
          id: follow_request_to_me_user2.id,
          userid: follow_request_to_me_user2.userid,
          username: follow_request_to_me_user2.username,
          image: follow_request_to_me_user2.image.url,
          bio: follow_request_to_me_user2.bio,
          need_description_about_lock: follow_request_to_me_user2.need_description_about_lock
        )
      end

      it 'returns 200 and follow requested user when client has a follow requested user' do
        # current_userがフォローリクエストしているユーザが1人いることを確認
        expect(FollowRequest.where(requested_by: follow_request_to_me_user1.id, request_to: client_user.id)).to exist
        expect(FollowRequest.where(request_to: client_user.id).length).to eq(1)

        # API
        get v1_follow_request_to_me_users_path, headers: headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォローリクエストしているユーザ1人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(1)
        expect(response_body[0].length).to eq(6)
        expect(response_body[0]).to include(
          id: follow_request_to_me_user1.id,
          userid: follow_request_to_me_user1.userid,
          username: follow_request_to_me_user1.username,
          image: follow_request_to_me_user1.image.url,
          bio: follow_request_to_me_user1.bio,
          need_description_about_lock: follow_request_to_me_user1.need_description_about_lock
        )
      end

      it "returns 200 and no users when client has no follow requested users" do
        expect(FollowRequest.where(requested_by: client_user.id)).not_to exist

        get v1_follow_request_to_me_users_path, headers: headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(0)
      end
    end
  end
end

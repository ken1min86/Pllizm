require 'rails_helper'

RSpec.describe "UsersApi", type: :request do
  describe "GET /v1/follow_requested_by_me_users - v1/users#index_of_users_follow_requested_by_me - Get users requested by me" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_follow_requested_by_me_users_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        sign_up(Faker::Name.first_name)
        @client_user = get_current_user_by_response(response)
        @headers = create_header_from_response(response)
      end

      let(:follow_requested_user1) { create_follow_requested_user_by_argument_user(@client_user) }
      let(:follow_requested_user2) { create_follow_requested_user_by_argument_user(@client_user) }

      it 'returns 200 and follow requested users when client has some follow requested users' do
        # current_userがフォローリクエストしているユーザが2人いることを確認
        expect(FollowRequest.where(requested_by: @client_user.id, request_to: follow_requested_user1.id)).to exist
        expect(FollowRequest.where(requested_by: @client_user.id, request_to: follow_requested_user2.id)).to exist
        expect(FollowRequest.where(requested_by: @client_user.id).length).to eq(2)

        # API
        get v1_follow_requested_by_me_users_path, headers: @headers
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
        expect(FollowRequest.where(requested_by: @client_user.id, request_to: follow_requested_user1.id)).to exist
        expect(FollowRequest.where(requested_by: @client_user.id).length).to eq(1)

        # API
        get v1_follow_requested_by_me_users_path, headers: @headers
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
        expect(FollowRequest.where(requested_by: @client_user.id)).not_to exist

        get v1_follow_requested_by_me_users_path, headers: @headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(0)
      end
    end
  end
end

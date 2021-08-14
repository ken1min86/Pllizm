require 'rails_helper'

RSpec.describe "GET /v1/mutual_follow_users - v1/mutual_follow_users#index - Get mutual follow users", type: :request do
  describe "GET /index" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_mutual_follow_users_path
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

      let(:mutual_follow_user1) { create_mutual_follow_user(@client_user) }
      let(:mutual_follow_user2) { create_mutual_follow_user(@client_user) }

      it 'returns 200 and mutual follow users when client has some mutual follow users' do
        # current_userのフォロアーが2人いることを確認
        expect(Follower.where(followed_by: @client_user.id, follow_to: mutual_follow_user1.id)).to exist
        expect(Follower.where(followed_by: @client_user.id, follow_to: mutual_follow_user2.id)).to exist
        expect(Follower.where(followed_by: @client_user.id).length).to eq(2)

        # API
        get v1_mutual_follow_users_path, headers: @headers
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
        expect(Follower.where(followed_by: @client_user.id, follow_to: mutual_follow_user1.id)).to exist
        expect(Follower.where(followed_by: @client_user.id).length).to eq(1)

        # API
        get v1_mutual_follow_users_path, headers: @headers
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
        expect(Follower.where(followed_by: @client_user.id)).not_to exist

        get v1_mutual_follow_users_path, headers: @headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(0)
      end
    end
  end
end

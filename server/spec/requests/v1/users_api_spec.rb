require 'rails_helper'

RSpec.describe "V1::UsersApi", type: :request do
  describe "GET /v1/followers - v1/users#index_of_followers - Get followers" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_follow_users_path
        expect(response).to         have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user)  { create(:user) }
      let(:headers)      { client_user.create_new_auth_token }
      let(:follow_user1) { create_follow_user(client_user) }
      let(:follow_user2) { create_follow_user(client_user) }

      it 'returns 200 and follow users when client has some follow users' do
        # current_userのフォロアーが2人いることを確認
        expect(Follower.where(followed_by: client_user.id, follow_to: follow_user1.id)).to exist
        expect(Follower.where(followed_by: client_user.id, follow_to: follow_user2.id)).to exist
        expect(Follower.where(followed_by: client_user.id).length).to eq(2)

        # API
        get v1_follow_users_path, headers: headers
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォロアー2人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to    eq(2)
        expect(response_body[0].length).to eq(6)
        expect(response_body[1].length).to eq(6)
        expect(response_body[0]).to        include(
          id: follow_user1.id,
          userid: follow_user1.userid,
          username: follow_user1.username,
          image: follow_user1.image.url,
          bio: follow_user1.bio,
          need_description_about_lock: follow_user1.need_description_about_lock
        )
        expect(response_body[1]).to include(
          id: follow_user2.id,
          userid: follow_user2.userid,
          username: follow_user2.username,
          image: follow_user2.image.url,
          bio: follow_user2.bio,
          need_description_about_lock: follow_user2.need_description_about_lock
        )
      end

      it 'returns 200 and follow user when client has a follow user' do
        # current_userのフォロアーが1人いることを確認
        expect(Follower.where(followed_by: client_user.id, follow_to: follow_user1.id)).to exist
        expect(Follower.where(followed_by: client_user.id).length).to eq(1)

        # API
        get v1_follow_users_path, headers: headers
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォロアー1人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to    eq(1)
        expect(response_body[0].length).to eq(6)
        expect(response_body[0]).to        include(
          id: follow_user1.id,
          userid: follow_user1.userid,
          username: follow_user1.username,
          image: follow_user1.image.url,
          bio: follow_user1.bio,
          need_description_about_lock: follow_user1.need_description_about_lock
        )
      end

      it "returns 200 and no users when client has no follow users" do
        expect(Follower.where(followed_by: client_user.id)).not_to exist

        get v1_follow_users_path, headers: headers
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(0)
      end
    end
  end

  describe "GET /v1/follow_requests/outgoing - v1/users#index_of_users_follow_requested_by_me - Get users requested by me" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_follow_requested_by_me_users_path
        expect(response).to         have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user)            { create(:user) }
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
        expect(response).to         have_http_status(200)
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
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォローリクエストしているユーザ1人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to    eq(1)
        expect(response_body[0].length).to eq(6)
        expect(response_body[0]).to        include(
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
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(0)
      end
    end
  end

  describe "GET /v1/follow_requests/incoming - v1/users#index_of_users_follow_request_to_me - Get users requested to me" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_follow_request_to_me_users_path
        expect(response).to         have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user)                { create(:user) }
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
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォローリクエストしているユーザ2人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to    eq(2)
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

        get v1_follow_request_to_me_users_path, headers: headers
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォローリクエストしているユーザ1人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to    eq(1)
        expect(response_body[0].length).to eq(6)
        expect(response_body[0]).to        include(
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
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(0)
      end
    end
  end

  describe "PUT /v1/disable_lock_description - v1/users#disable_lock_description - Disable lock description" do
    context "when client doesn't have token" do
      it "returns 401" do
        put v1_disableLockDescription_path
        expect(response).to         have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        sign_up(Faker::Name.first_name)
        @request_headers = create_header_from_response(response)
        @current_user    = get_current_user_by_response(response)
      end

      it 'returns 200 and change false when need_description_about_lock is true' do
        expect(@current_user.need_description_about_lock).to eq(true)

        put v1_disableLockDescription_path, headers: @request_headers
        @current_user.reload
        expect(@current_user.need_description_about_lock).to eq(false)
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')
      end

      it 'returns 200 and keep false when need_description_about_lock is false' do
        @current_user.update(need_description_about_lock: false)
        expect(@current_user.need_description_about_lock).to eq(false)

        put v1_disableLockDescription_path, headers: @request_headers
        @current_user.reload
        expect(@current_user.need_description_about_lock).to eq(false)
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')
      end
    end
  end

  describe "GET /v1/search/users - v1/users#index_searched_users - Search for users" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_searched_users_path
        expect(response).to         have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user) { create(:user, userid: 'client', username: 'client') }
      let(:headers)     { client_user.create_new_auth_token }

      context "when no query parameter is set" do
        it 'returns 400' do
          get v1_searched_users_path, headers: headers
          expect(response).to         have_http_status(400)
          expect(response.message).to include('Bad Request')
        end
      end

      context "when there are 1 user icluding front part matching userid
      and 1 user icluding front part matching username" do
        let!(:user_including_front_part_match_userid)   { create(:user, userid: 'test', username: 'Tanaka') }
        let!(:user_including_front_part_match_username) { create(:user, userid: 'takuto0320', username: 'test') }
        let(:q) { 'test' }

        it 'returns 200 and 2 formatted users' do
          get v1_searched_users_path(q: q), headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:users].length).to eq(2)
          expect(response_body[:users][0]).to     include(
            userid: user_including_front_part_match_userid.userid,
            username: user_including_front_part_match_userid.username,
            image: user_including_front_part_match_userid.image.url,
            bio: user_including_front_part_match_userid.bio
          )
          expect(response_body[:users][1]).to include(
            userid: user_including_front_part_match_username.userid,
            username: user_including_front_part_match_username.username,
            image: user_including_front_part_match_username.image.url,
            bio: user_including_front_part_match_username.bio
          )
        end
      end

      context "when there are 3 users icluding different length of front part matching userid
      and 2 users icluding different length of front part matching username
      and 1 user icluding front part matching userid and username" do
        let!(:user1_including_front_part_match_userid)             { create(:user, userid: 'test', username: 'Tanaka') }
        let!(:user2_including_front_part_match_userid)             { create(:user, userid: 'test1', username: 'Takada') }
        let!(:user3_including_front_part_match_userid)             { create(:user, userid: 'test123', username: 'Nakada') }
        let!(:user1_including_front_part_match_username)           { create(:user, userid: 'takuto0320', username: 'test12') }
        let!(:user2_including_front_part_match_username)           { create(:user, userid: 'ataka0210', username: 'test1234') }
        let!(:user_including_front_part_match_userid_and_username) { create(:user, userid: 'test12345', username: 'test12345') }
        let(:q) { 'test' }

        it 'returns 200 and 6 formatted users sorted by degree of match' do
          get v1_searched_users_path(q: q), headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:users].length).to      eq(6)
          expect(response_body[:users][0][:userid]).to eq(user1_including_front_part_match_userid.userid)
          expect(response_body[:users][1][:userid]).to eq(user2_including_front_part_match_userid.userid)
          expect(response_body[:users][2][:userid]).to eq(user1_including_front_part_match_username.userid)
          expect(response_body[:users][3][:userid]).to eq(user3_including_front_part_match_userid.userid)
          expect(response_body[:users][4][:userid]).to eq(user2_including_front_part_match_username.userid)
          expect(response_body[:users][5][:userid]).to eq(user_including_front_part_match_userid_and_username.userid)
        end
      end
    end
  end
end

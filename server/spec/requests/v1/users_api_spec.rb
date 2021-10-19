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
      let(:follower1) { create_follower(client_user) }
      let(:follower2) { create_follower(client_user) }

      it 'returns 200 and follow users when client has some follow users' do
        # current_userのフォロアーが2人いることを確認
        expect(Follower.where(followed_by: client_user.id, follow_to: follower1.id)).to exist
        expect(Follower.where(followed_by: client_user.id, follow_to: follower2.id)).to exist
        expect(Follower.where(followed_by: client_user.id).length).to eq(2)

        # API
        get v1_follow_users_path, headers: headers
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォロアー2人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:users].length).to    eq(2)
        expect(response_body[:users][0].length).to eq(4)
        expect(response_body[:users][1].length).to eq(4)
        expect(response_body[:users][0]).to        include(
          user_id: follower1.userid,
          user_name: follower1.username,
          icon_url: follower1.image.url,
          bio: follower1.bio,
        )
        expect(response_body[:users][1]).to include(
          user_id: follower2.userid,
          user_name: follower2.username,
          icon_url: follower2.image.url,
          bio: follower2.bio,
        )
      end

      it 'returns 200 and follow user when client has a follow user' do
        # current_userのフォロアーが1人いることを確認
        expect(Follower.where(followed_by: client_user.id, follow_to: follower1.id)).to exist
        expect(Follower.where(followed_by: client_user.id).length).to eq(1)

        # API
        get v1_follow_users_path, headers: headers
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        # レスポンスボディのデータがフォロアー1人分で、仕様書通りのカラムのみ返していることを確認
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:users].length).to    eq(1)
        expect(response_body[:users][0].length).to eq(4)
        expect(response_body[:users][0]).to        include(
          user_id: follower1.userid,
          user_name: follower1.username,
          icon_url: follower1.image.url,
          bio: follower1.bio,
        )
      end

      it "returns 200 and no users when client has no follow users" do
        expect(Follower.where(followed_by: client_user.id)).not_to exist

        get v1_follow_users_path, headers: headers
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:users].length).to eq(0)
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
        expect(response_body[:users].length).to eq(2)
        expect(response_body[:users][0].length).to eq(4)
        expect(response_body[:users][1].length).to eq(4)
        expect(response_body[:users][0]).to include(
          user_id: follow_requested_user1.userid,
          user_name: follow_requested_user1.username,
          icon_url: follow_requested_user1.image.url,
          bio: follow_requested_user1.bio,
        )
        expect(response_body[:users][1]).to include(
          user_id: follow_requested_user2.userid,
          user_name: follow_requested_user2.username,
          icon_url: follow_requested_user2.image.url,
          bio: follow_requested_user2.bio,
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
        expect(response_body[:users].length).to    eq(1)
        expect(response_body[:users][0].length).to eq(4)
        expect(response_body[:users][0]).to        include(
          user_id: follow_requested_user1.userid,
          user_name: follow_requested_user1.username,
          icon_url: follow_requested_user1.image.url,
          bio: follow_requested_user1.bio,
        )
      end

      it "returns 200 and no users when client has no follow requested users" do
        expect(FollowRequest.where(requested_by: client_user.id)).not_to exist

        get v1_follow_requested_by_me_users_path, headers: headers
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:users].length).to eq(0)
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
        expect(response_body[:users].length).to    eq(2)
        expect(response_body[:users][0].length).to eq(4)
        expect(response_body[:users][1].length).to eq(4)

        expect(response_body[:users][0]).to include(
          user_id: follow_request_to_me_user1.userid,
          user_name: follow_request_to_me_user1.username,
          icon_url: follow_request_to_me_user1.image.url,
          bio: follow_request_to_me_user1.bio,
        )
        expect(response_body[:users][1]).to include(
          user_id: follow_request_to_me_user2.userid,
          user_name: follow_request_to_me_user2.username,
          icon_url: follow_request_to_me_user2.image.url,
          bio: follow_request_to_me_user2.bio,
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
        expect(response_body[:users].length).to    eq(1)
        expect(response_body[:users][0].length).to eq(4)
        expect(response_body[:users][0]).to        include(
          user_id: follow_request_to_me_user1.userid,
          user_name: follow_request_to_me_user1.username,
          icon_url: follow_request_to_me_user1.image.url,
          bio: follow_request_to_me_user1.bio,
        )
      end

      it "returns 200 and no users when client has no follow requested users" do
        expect(FollowRequest.where(requested_by: client_user.id)).not_to exist

        get v1_follow_request_to_me_users_path, headers: headers
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:users].length).to eq(0)
      end
    end
  end

  describe "PUT /v1/disable_lock_description - v1/users#disable_lock_description - Disable lock description" do
    context "when client doesn't have token" do
      it "returns 401" do
        put v1_disable_lock_description_path
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

        put v1_disable_lock_description_path, headers: @request_headers
        @current_user.reload
        expect(@current_user.need_description_about_lock).to eq(false)
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')
      end

      it 'returns 200 and keep false when need_description_about_lock is false' do
        @current_user.update(need_description_about_lock: false)
        expect(@current_user.need_description_about_lock).to eq(false)

        put v1_disable_lock_description_path, headers: @request_headers
        @current_user.reload
        expect(@current_user.need_description_about_lock).to eq(false)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end
    end
  end

  describe "GET /v1/search/users - v1/users#index_searched_users - Search for users" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_searched_users_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user) { create(:user, userid: 'client', username: 'client') }
      let(:headers)     { client_user.create_new_auth_token }

      context "when no query parameter is set" do
        it 'returns 400' do
          get v1_searched_users_path, headers: headers
          expect(response).to have_http_status(400)
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
            user_id: user_including_front_part_match_userid.userid,
            user_name: user_including_front_part_match_userid.username,
            image_url: user_including_front_part_match_userid.image.url,
            bio: user_including_front_part_match_userid.bio
          )
          expect(response_body[:users][1]).to include(
            user_id: user_including_front_part_match_username.userid,
            user_name: user_including_front_part_match_username.username,
            image_url: user_including_front_part_match_username.image.url,
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
          expect(response_body[:users].length).to       eq(6)
          expect(response_body[:users][0][:user_id]).to eq(user1_including_front_part_match_userid.userid)
          expect(response_body[:users][1][:user_id]).to eq(user2_including_front_part_match_userid.userid)
          expect(response_body[:users][2][:user_id]).to eq(user1_including_front_part_match_username.userid)
          expect(response_body[:users][3][:user_id]).to eq(user3_including_front_part_match_userid.userid)
          expect(response_body[:users][4][:user_id]).to eq(user2_including_front_part_match_username.userid)
          expect(response_body[:users][5][:user_id]).to eq(user_including_front_part_match_userid_and_username.userid)
        end
      end
    end
  end

  describe "GET /v1/users/:id - v1/users#show_user_info - Get user info" do
    context "when client doesn't have token" do
      let(:client_user) { create(:user) }

      it "returns 401" do
        get v1_user_info_path(client_user.id)
        expect(response).to         have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user) { create(:user) }
      let(:headers)     { client_user.create_new_auth_token }

      context "when psrams[:id] isn't set" do
        it 'returns 400' do
          get v1_user_info_path(' '), headers: headers
          expect(response).to         have_http_status(400)
          expect(response.message).to include('Bad Request')
          expect(JSON.parse(response.body)['errors']['title']).to include('パラメータのidが不正です')
        end
      end

      context "when params[:id] isn't relate to User" do
        let(:not_existent_userid) { get_not_existent_userid }

        it 'returns 400' do
          get v1_user_info_path(not_existent_userid), headers: headers
          expect(response).to         have_http_status(400)
          expect(response.message).to include('Bad Request')
          expect(JSON.parse(response.body)['errors']['title']).to include('パラメータのidが不正です')
        end
      end

      context "when params[:id] is related to current user
      who has 0 follower, 1 follow request to him and 2 follow requests by him" do
        before do
          create_user_to_request_follow_to_argument_user(client_user)
          create_follow_requested_user_by_argument_user(client_user)
          create_follow_requested_user_by_argument_user(client_user)
        end

        it 'returns 200 and current user info' do
          get v1_user_info_path(client_user.userid), headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to include(
            is_current_user: true,
            icon_url: client_user.image.url,
            user_name: client_user.username,
            user_id: client_user.userid,
            bio: client_user.bio,
            followers_count: 0,
            follow_requests_to_me_count: 1,
            follow_requests_by_me_count: 2,
            following: false,
            follow_request_sent_to_me: false,
            follow_requet_sent_by_me: false
          )
        end
      end

      context "when params[:id] is related to current user
      who has 1 follower, 2 follow requests to him and 0 follow request by him" do
        before do
          create_follower(client_user)
          create_user_to_request_follow_to_argument_user(client_user)
          create_user_to_request_follow_to_argument_user(client_user)
        end

        it 'returns 200 and current user info' do
          get v1_user_info_path(client_user.userid), headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to include(
            followers_count: 1,
            follow_requests_to_me_count: 2,
            follow_requests_by_me_count: 0,
          )
        end
      end

      context "when params[:id] is related to current user
      who has 2 followers, 0 follow request to him and 1 follow requests by him" do
        before do
          create_follower(client_user)
          create_follower(client_user)
          create_follow_requested_user_by_argument_user(client_user)
        end

        it 'returns 200 and current user info' do
          get v1_user_info_path(client_user.userid), headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to include(
            followers_count: 2,
            follow_requests_to_me_count: 0,
            follow_requests_by_me_count: 1,
          )
        end
      end

      context "when params[:id] is related to user except current user
      who has been following current user,
      hasn't requested following to current user
      and hasn't been requested following by current user" do
        let(:not_current_user) { create_follower(client_user) }

        it 'returns 200 and current user info' do
          get v1_user_info_path(not_current_user.userid), headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to include(
            is_current_user: false,
            icon_url: not_current_user.image.url,
            user_name: not_current_user.username,
            user_id: not_current_user.userid,
            bio: not_current_user.bio,
            followers_count: nil,
            follow_requests_to_me_count: nil,
            follow_requests_by_me_count: nil,
            following: true,
            follow_request_sent_to_me: false,
            follow_requet_sent_by_me: false
          )
        end
      end

      context "when params[:id] is related to user except current user
      who hasn't been following current user,
      has requested following to current user
      and hasn't been requested following by current user" do
        let(:not_current_user) { create_user_to_request_follow_to_argument_user(client_user) }

        it 'returns 200 and current user info' do
          get v1_user_info_path(not_current_user.userid), headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to include(
            following: false,
            follow_request_sent_to_me: true,
            follow_requet_sent_by_me: false
          )
        end
      end

      context "when params[:id] is related to user except current user
      who hasn't been following current user,
      hasn't requested following to current user
      and has been requested following by current user" do
        let(:not_current_user) { create_follow_requested_user_by_argument_user(client_user) }

        it 'returns 200 and current user info' do
          get v1_user_info_path(not_current_user.userid), headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to include(
            following: false,
            follow_request_sent_to_me: false,
            follow_requet_sent_by_me: true
          )
        end
      end
    end
  end

  describe "GET /v1/right_to_use_app - v1/users#right_to_use_app - Get whether user has right to use app" do
    context "when client doesn't have token" do
      let(:client_user) { create(:user) }

      it "returns 401" do
        get v1_right_to_use_app_path, headers: headers
        expect(response).to         have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user) { create(:user) }
      let(:headers)     { client_user.create_new_auth_token }

      context "when client has 0 follower" do
        it 'returns 200 and false' do
          expect(client_user.get_num_of_followers).to eq(0)
          get v1_right_to_use_app_path, headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to include(
            right_to_use_app: false
          )
        end
      end

      context "when client has 1 follower" do
        before do
          create_follower(client_user)
        end

        it 'returns 200 and false' do
          expect(client_user.get_num_of_followers).to eq(1)
          get v1_right_to_use_app_path, headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to include(
            right_to_use_app: false
          )
        end
      end

      context "when client has 2 followers" do
        before do
          create_follower(client_user)
          create_follower(client_user)
        end

        it 'returns 200 and false' do
          expect(client_user.get_num_of_followers).to eq(2)
          get v1_right_to_use_app_path, headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to include(
            right_to_use_app: true
          )
        end
      end
    end
  end
end

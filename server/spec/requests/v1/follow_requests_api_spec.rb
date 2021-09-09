require 'rails_helper'

RSpec.describe "V1::FollowRequestsApi", type: :request do
  describe "POST /v1/follow_requests/create - v1/follow_requests#create - Follow request" do
    context "when client doesn't have token" do
      let(:request_to) { create(:user) }

      it "returns 401" do
        expect do
          post v1_follow_requests_path, params: {
            request_to: request_to.userid,
          }
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:request_to)   { create(:user) }
      let(:requested_by) { create(:user) }
      let(:headers)      { requested_by.create_new_auth_token }
      let(:ken10806)     { create(:user, userid: Settings.users_to_follow_immediately[0]) }
      let(:jun_okada)    { create(:user, userid: Settings.users_to_follow_immediately[1]) }

      it 'returns 200' do
        expect(FollowRequest.where(requested_by: requested_by.id, request_to: request_to.id)).not_to exist

        post v1_follow_requests_path, params: {
          request_to: request_to.userid,
        }, headers: headers

        expect(FollowRequest.where(requested_by: requested_by.id, request_to: request_to.id)).to exist
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it 'returns 200 when request to user whose userid is ken10806' do
        post v1_follow_requests_path, params: {
          request_to: ken10806.userid,
        }, headers: headers

        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
        expect(Follower.where(followed_by: requested_by.id, follow_to: ken10806.id)).to exist
        expect(Follower.where(followed_by: ken10806.id, follow_to: requested_by.id)).to exist
      end

      it 'returns 200 when request to user whose userid is jun_okada' do
        post v1_follow_requests_path, params: {
          request_to: jun_okada.userid,
        }, headers: headers

        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
        expect(Follower.where(followed_by: requested_by.id, follow_to: jun_okada.id)).to exist
        expect(Follower.where(followed_by: jun_okada.id, follow_to: requested_by.id)).to exist
      end

      it "returns 400 without request_to" do
        expect do
          post v1_follow_requests_path, headers: headers
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('リクエスト対象のユーザが見つかりません')
      end

      it "returns 400 when request_to doesn't relate to user" do
        expect do
          post v1_follow_requests_path, params: {
            request_to: get_non_existent_user_id,
          }, headers: headers
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('リクエスト対象のユーザが見つかりません')
      end

      it "returns 400 when client has already requested followings" do
        requested_by.follow_requests.create(request_to: request_to.id)
        expect(FollowRequest.where(requested_by: requested_by.id, request_to: request_to.id)).to exist

        expect do
          post v1_follow_requests_path, params: {
            request_to: request_to.userid,
          }, headers: headers
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('すでにフォローリクエスト済みです')
      end

      it "returns 400 when client has already been requested followings" do
        request_to.follow_requests.create(request_to: requested_by.id)
        expect(FollowRequest.where(requested_by: request_to.id, request_to: requested_by.id)).to exist

        expect do
          post v1_follow_requests_path, params: {
            request_to: request_to.userid,
          }, headers: headers
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('フォローリクエストされています')
      end

      it "returns 400 when client has already followed the user" do
        requested_by.follow_relationships.create(follow_to: request_to.id)
        expect(Follower.where(followed_by: requested_by.id, follow_to: request_to.id)).to exist

        expect do
          post v1_follow_requests_path, params: {
            request_to: request_to.userid,
          }, headers: headers
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('すでにフォロー中です')
      end

      it "returns 400 when client request following to client" do
        expect do
          post v1_follow_requests_path, params: {
            request_to: requested_by.userid,
          }, headers: headers
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('自身に対するフォローリクエストです')
      end
    end
  end

  describe "DELETE /v1/follow_requests/refuse - v1/follow_requests#destroy_follow_requests_to_me - Refuse follow request" do
    context "when client doesn't have token" do
      let(:user) { create(:user) }

      it "returns 401" do
        expect do
          delete v1_follow_requests_to_me_path, params: {
            requested_by: user.userid,
          }
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:request_follow_user) { create(:user) }
      let(:client_user)         { create(:user) }
      let(:headers)             { client_user.create_new_auth_token }

      it 'returns 200 and delete follow request' do
        request_follow_user.follow_requests.create(request_to: client_user.id)

        expect do
          delete v1_follow_requests_to_me_path, params: {
            requested_by: request_follow_user.userid,
          }, headers: headers
        end.to change(FollowRequest.where(requested_by: request_follow_user.id, request_to: client_user.id), :count).by(-1)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 400 when client hasn't been requested follow" do
        expect(FollowRequest.where(requested_by: request_follow_user.id, request_to: client_user.id)).not_to exist

        delete v1_follow_requests_to_me_path, params: {
          requested_by: request_follow_user.userid,
        }, headers: headers
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('フォローリクエストされていません')
      end
    end
  end

  describe "DELETE /v1/follow_requests/outgoing - v1/follow_requests#destroy_follow_requests_by_me - Withdraw follow request" do
    context "when client doesn't have token" do
      let(:request_to_user) { create(:user) }

      it "returns 401" do
        expect do
          delete v1_follow_requests_by_me_path, params: {
            request_to: request_to_user.userid,
          }
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:request_to_user) { create(:user) }
      let(:client_user)     { create(:user) }
      let(:headers)         { client_user.create_new_auth_token }

      it 'returns 200 and delete follow request' do
        client_user.follow_requests.create(request_to: request_to_user.id)

        expect do
          delete v1_follow_requests_by_me_path, params: {
            request_to: request_to_user.userid,
          }, headers: headers
        end.to change(FollowRequest.where(requested_by: client_user.id, request_to: request_to_user.id), :count).by(-1)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 400 when client hasn't requested follow" do
        expect do
          delete v1_follow_requests_by_me_path, params: {
            request_to: request_to_user.userid,
          }, headers: headers
        end.to change(FollowRequest.where(requested_by: client_user.id, request_to: request_to_user.id), :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('フォローリクエストしていません')
      end
    end
  end
end

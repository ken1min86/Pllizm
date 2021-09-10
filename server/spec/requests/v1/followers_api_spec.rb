require 'rails_helper'

RSpec.describe "V1::FollowersApi", type: :request do
  describe "POST /v1/follow_requests/accept - v1/followers#create - Accept follow request" do
    context "when client doesn't have token" do
      let(:user) { create(:user) }

      it "returns 401" do
        post v1_followers_path, params: {
          follow_to: user.userid,
        }
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user) { create(:user) }
      let(:headers)     { client_user.create_new_auth_token }
      let(:follow_user) { create(:user) }

      it 'returns 200 and deletes follow_request and create followers' do
        follow_user.follow_requests.create(request_to: client_user.id)
        expect(FollowRequest.where(requested_by: follow_user.id, request_to: client_user.id)).to exist
        expect(Follower.where(followed_by: client_user.id, follow_to: follow_user.id)).not_to exist
        expect(Follower.where(followed_by: follow_user.id, follow_to: client_user.id)).not_to exist
        expect(Notification.where(notify_user_id: client_user.id, action: 'accept')).not_to exist

        post v1_followers_path, params: {
          follow_to: follow_user.userid,
        }, headers: headers
        expect(FollowRequest.where(requested_by: follow_user.id, request_to: client_user.id)).not_to exist
        expect(Follower.where(followed_by: client_user.id, follow_to: follow_user.id)).to exist
        expect(Follower.where(followed_by: follow_user.id, follow_to: client_user.id)).to exist
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
        expect(Notification.where(notify_user_id: client_user.id, notified_user_id: follow_user.id, action: 'accept')).to exist
      end

      it "returns 400 when client haven't requested following" do
        expect(FollowRequest.where(requested_by: follow_user.id, request_to: client_user.id)).not_to exist
        expect(Follower.where(followed_by: client_user.id, follow_to: follow_user.id)).not_to exist
        expect(Follower.where(followed_by: follow_user.id, follow_to: client_user.id)).not_to exist

        post v1_followers_path, params: {
          follow_to: follow_user.userid,
        }, headers: headers

        expect(Follower.where(followed_by: client_user.id, follow_to: follow_user.id)).not_to exist
        expect(Follower.where(followed_by: follow_user.id, follow_to: client_user.id)).not_to exist
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('フォローリクエストされていません')
      end
    end
  end

  describe "DELETE /v1/follower - v1/followers#destroy - Cancel follow" do
    context "when client doesn't have token" do
      let(:follower) { create(:user) }

      it "returns 401" do
        delete v1_follower_path(follower_id: follower.userid)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      let(:client_user) { create(:user) }
      let(:headers)     { client_user.create_new_auth_token }
      let(:follower)    { create(:user) }

      it 'returns 200 and deletes followers' do
        client_user.follow_relationships.create(follow_to: follower.id)
        follower.follow_relationships.create(follow_to: client_user.id)
        expect(Follower.where(followed_by: client_user.id, follow_to: follower.id)).to exist
        expect(Follower.where(followed_by: follower.id, follow_to: client_user.id)).to exist

        delete v1_follower_path(follower_id: follower.userid), headers: headers
        expect(Follower.where(followed_by: client_user.id, follow_to: follower.id)).not_to exist
        expect(Follower.where(followed_by: follower.id, follow_to: client_user.id)).not_to exist
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 400 when client haven't mutually followed" do
        expect(Follower.where(followed_by: client_user.id, follow_to: follower.id)).not_to exist
        expect(Follower.where(followed_by: follower.id, follow_to: client_user.id)).not_to exist

        delete v1_follower_path(follower_id: follower.userid), headers: headers
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('フォローしていません')
      end
    end
  end
end

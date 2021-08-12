require 'rails_helper'

RSpec.describe "FollowersApi", type: :request do
  describe "POST /v1/followers - v1/followers#create - Approve follow request" do
    context "when client doesn't have token" do
      it "returns 401" do
        sign_up(Faker::Name.first_name)
        user = get_current_user_by_response(response)
        post v1_followers_path, params: {
          follow_to: user.id,
        }
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

      let(:follow_user) { FactoryBot.create(:user) }

      it 'returns 200 and deletes follow_request and create followers' do
        follow_user.follow_requests.create(request_to: @client_user.id)
        expect(FollowRequest.where(requested_by: follow_user.id, request_to: @client_user.id)).to exist
        expect(Follower.where(followed_by: @client_user.id, follow_to: follow_user.id)).not_to exist
        expect(Follower.where(followed_by: follow_user.id, follow_to: @client_user.id)).not_to exist

        post v1_followers_path, params: {
          follow_to: follow_user.id,
        }, headers: @headers
        expect(FollowRequest.where(requested_by: follow_user.id, request_to: @client_user.id)).not_to exist
        expect(Follower.where(followed_by: @client_user.id, follow_to: follow_user.id)).to exist
        expect(Follower.where(followed_by: follow_user.id, follow_to: @client_user.id)).to exist
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 400 when client haven't requested following" do
        expect(FollowRequest.where(requested_by: follow_user.id, request_to: @client_user.id)).not_to exist
        expect(Follower.where(followed_by: @client_user.id, follow_to: follow_user.id)).not_to exist
        expect(Follower.where(followed_by: follow_user.id, follow_to: @client_user.id)).not_to exist

        post v1_followers_path, params: {
          follow_to: follow_user.id,
        }, headers: @headers

        expect(Follower.where(followed_by: @client_user.id, follow_to: follow_user.id)).not_to exist
        expect(Follower.where(followed_by: follow_user.id, follow_to: @client_user.id)).not_to exist
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('フォローリクエストされていません')
      end
    end
  end
end

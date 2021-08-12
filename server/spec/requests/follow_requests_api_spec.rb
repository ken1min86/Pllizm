require 'rails_helper'

RSpec.describe "FollowRequestsApi", type: :request do
  describe "POST /v1/follow_requests - v1/follow_requests#create - Follow request" do
    context "when client doesn't have token" do
      it "returns 401" do
        sign_up(Faker::Name.first_name)
        request_to = get_current_user_by_response(response)
        expect do
          post v1_follow_requests_path, params: {
            request_to: request_to.id,
          }
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        sign_up('toru')
        @request_to = get_current_user_by_response(response)
        sign_up('kasai')
        @requested_by = get_current_user_by_response(response)
        @header = create_header_from_response(response)
      end

      it 'returns 200' do
        expect(FollowRequest.where(requested_by: @requested_by.id, request_to: @request_to.id)).not_to exist

        post v1_follow_requests_path, params: {
          request_to: @request_to.id,
        }, headers: @header

        expect(FollowRequest.where(requested_by: @requested_by.id, request_to: @request_to.id)).to exist
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 400 without request_to" do
        expect do
          post v1_follow_requests_path, headers: @header
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('リクエスト対象のユーザが見つかりません')
      end

      it "returns 400 when request_to doesn't relate to user" do
        expect do
          post v1_follow_requests_path, params: {
            request_to: get_non_existemt_user_id,
          }, headers: @header
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('リクエスト対象のユーザが見つかりません')
      end

      it "returns 400 when client has already requested followings" do
        @requested_by.follow_requests.create(request_to: @request_to.id)
        expect(FollowRequest.where(requested_by: @requested_by.id, request_to: @request_to.id)).to exist

        expect do
          post v1_follow_requests_path, params: {
            request_to: @request_to.id,
          }, headers: @header
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('すでにフォローリクエスト済みです')
      end

      it "returns 400 when client has already been requested followings" do
        @request_to.follow_requests.create(request_to: @requested_by.id)
        expect(FollowRequest.where(requested_by: @request_to.id, request_to: @requested_by.id)).to exist

        expect do
          post v1_follow_requests_path, params: {
            request_to: @request_to.id,
          }, headers: @header
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('フォローリクエストされています')
      end

      it "returns 400 when client has already followed the user" do
        @requested_by.follow_relationships.create(follow_to: @request_to.id)
        expect(Follower.where(followed_by: @requested_by.id, follow_to: @request_to.id)).to exist

        expect do
          post v1_follow_requests_path, params: {
            request_to: @request_to.id,
          }, headers: @header
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('すでにフォロー中です')
      end

      it "returns 400 when client request following to client" do
        expect do
          post v1_follow_requests_path, params: {
            request_to: @requested_by.id,
          }, headers: @header
        end.to change(FollowRequest.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
        expect(JSON.parse(response.body)['errors']['title']).to include('自身に対するフォローリクエストです')
      end
    end
  end
end

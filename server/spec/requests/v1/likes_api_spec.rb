require 'rails_helper'

RSpec.describe "V1::LikesApi", type: :request do
  describe "POST /v1/posts/:id/likess - v1/likes#create - Create likes" do
    context "when client doesn't have token" do
      before do
        create(:icon)
      end

      let(:user)       { create(:user) }
      let(:liked_post) { create(:post, user_id: user.id) }

      it "returns 401" do
        expect { post v1_post_likes_path(liked_post.id) }.to change(Like.all, :count).by(0)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user) { create(:user) }
      let(:headers)     { client_user.create_new_auth_token }

      context "when try to like client's post" do
        let(:client_post) { create(:post, user_id: client_user.id) }

        it 'returns 200 and creates like record' do
          expect do
            post v1_post_likes_path(client_post.id), headers: headers
          end.to change(Like.where(user_id: client_user.id, post_id: client_post.id), :count).by(1)
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
        end
      end

      context "when try to like follower's post" do
        let(:follower)      { create_follow_user(client_user) }
        let(:follower_post) { create(:post, user_id: follower.id) }

        it 'returns 200 and creates like record' do
          expect do
            post v1_post_likes_path(follower_post.id), headers: headers
          end.to change(Like.where(user_id: client_user.id, post_id: follower_post.id), :count).by(1)
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
        end
      end

      context "when try to like not client's post and follower's post" do
        let(:not_follower)      { create(:user) }
        let(:not_follower_post) { create(:post, user_id: not_follower.id) }

        it 'returns 400' do
          expect do
            post v1_post_likes_path(not_follower_post.id), headers: headers
          end.to change(Like.all, :count).by(0)
          expect(response).to have_http_status(400)
          expect(response.message).to include('Bad Request')
          expect(JSON.parse(response.body)['errors']['title']).to include('いいね対象外の投稿です')
        end
      end

      context "when post_id doesn't relate to post" do
        let(:non_existent_post_id) { get_non_existent_post_id }

        it 'returns 400' do
          expect do
            post v1_post_likes_path(non_existent_post_id), headers: headers
          end.to change(Like.all, :count).by(0)
          expect(response).to have_http_status(400)
          expect(response.message).to include('Bad Request')
          expect(JSON.parse(response.body)['errors']['title']).to include('存在しない投稿です')
        end
      end
    end
  end
end

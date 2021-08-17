require 'rails_helper'

RSpec.describe "V1::LikesApi", type: :request do
  describe "POST /v1/posts/:post_id/likes - v1/likes#create - Create likes" do
    context "when client doesn't have token" do
      before do
        FactoryBot.create(:icon)
      end

      let(:user) { FactoryBot.create(:user) }
      let(:liked_post) { FactoryBot.create(:post, user_id: user.id) }

      it "returns 401" do
        expect { post v1_post_likes_path(liked_post.id) }.to change(Like.all, :count).by(0)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        FactoryBot.create(:icon)
      end

      let(:client_user) { FactoryBot.create(:user) }
      let(:headers) { client_user.create_new_auth_token }

      context "when try to like client's post" do
        let(:client_post) { FactoryBot.create(:post, user_id: client_user.id) }

        it 'returns 200 and creates like record' do
          expect do
            post v1_post_likes_path(client_post.id), headers: headers
          end.to change(Like.where(user_id: client_user.id, post_id: client_post.id), :count).by(1)
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
        end
      end

      context "when try to like mutual follower's post" do
        let(:mutual_follower) { create_mutual_follow_user(client_user) }
        let(:mutual_follower_post) { FactoryBot.create(:post, user_id: mutual_follower.id) }

        it 'returns 200 and creates like record' do
          expect do
            post v1_post_likes_path(mutual_follower_post.id), headers: headers
          end.to change(Like.where(user_id: client_user.id, post_id: mutual_follower_post.id), :count).by(1)
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
        end
      end

      context "when try to like not client's post and mutual follower's post" do
        let(:not_follower) { FactoryBot.create(:user) }
        let(:not_follower_post) { FactoryBot.create(:post, user_id: not_follower.id) }

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

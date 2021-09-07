require 'rails_helper'

RSpec.describe "V1::PostsApi", type: :request do
  describe "POST /v1/posts - v1/posts#create - Create new post" do
    context "when client doesn't have token" do
      it "returns 401" do
        post v1_posts_path, params: {
          "content": 'Hello!',
        }
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create_list(:icon, 5)
      end

      let(:client_user) { create(:user) }
      let(:headers)     { client_user.create_new_auth_token }

      it 'returns 200 and sets is_locked true when is_locked is true' do
        params = {
          content: 'Hello!',
          image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.png"), "image/png"),
          is_locked: true,
        }
        expect do
          post v1_posts_path, params: params, headers: headers
        end.to change(Post.all, :count).by(1)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        created_post = Post.find_by(user_id: get_current_user_by_response(response).id)

        expect(Icon.all.any? { |icon| created_post.icon_id == icon.id }).to be_truthy
        expect(created_post.is_locked).to eq(true)
        expect(created_post.content).to eq('Hello!')
      end

      it 'returns 200 and sets is_locked false when is_locked is nil' do
        params = {
          content: 'Hello!',
        }
        expect do
          post v1_posts_path, params: params, headers: headers
        end.to change(Post.all, :count).by(1)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')

        created_post = Post.find_by(user_id: get_current_user_by_response(response).id)

        expect(created_post.is_locked).to eq(false)
      end

      it "returns 200 when content has 140 characters" do
        params = {
          content: 'a' * 140,
        }
        expect do
          post v1_posts_path, params: params, headers: headers
        end.to change(Post.all, :count).by(1)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 400 when content has 141 characters" do
        params = {
          content: 'a' * 141,
        }
        post v1_posts_path, params: params, headers: headers
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end

      it "returns 400 when content is blank" do
        params = {
          content: '',
        }
        post v1_posts_path, params: params, headers: headers
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end

      it "returns 400 when content is nil" do
        params = {
          content: nil,
        }
        post v1_posts_path, params: params, headers: headers
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end

      it "returns 200 when image's extension isn't jpg or png or gif or jpeg" do
        params = {
          content: 'Hello!',
          image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.svg"), "image/svg"),
          is_locked: true,
        }
        post v1_posts_path, params: params, headers: headers
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end
    end
  end

  describe "DELETE /v1/posts - v1/posts#destroy - Delete login user's post" do
    context "when client doesn't have token" do
      before do
        create(:icon)
      end

      let(:client_user)       { create(:user) }
      let!(:client_user_post) { create(:post, user_id: client_user.id) }

      it "returns 401" do
        delete v1_post_path(client_user_post.id)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user)           { create(:user) }
      let(:headers)               { client_user.create_new_auth_token }
      let!(:client_user_post)     { create(:post, user_id: client_user.id) }
      let(:not_client_user)       { create(:user) }
      let!(:not_client_user_post) { create(:post, user_id: not_client_user.id) }

      it "returns 200 and logically deletes post when try to delete login user's post" do
        expect do
          delete v1_post_path(client_user_post.id), headers: headers
        end.to change(Post.all, :count).by(-1)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
        expect(Post.with_deleted.where(id: client_user_post.id).count).to eq 1
      end

      it "returns 400 when try to delete not login user's post" do
        expect do
          delete v1_post_path(not_client_user_post.id), headers: headers
        end.to change(Post.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end
    end
  end

  describe "PUT /v1/posts/:id/change_lock - v1/posts#change_lock - Change is_locked of login user's post" do
    context "when client doesn't have token" do
      before do
        create(:icon)
      end

      let(:user) { create(:user) }
      let(:post) { create(:post, user_id: user.id) }

      it "returns 401" do
        put v1_post_changeLock_path(post.id)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:user)              { create(:user) }
      let(:post)              { create(:post, user_id: user.id) }
      let(:headers)           { user.create_new_auth_token }
      let(:another_user)      { create(:user) }
      let(:another_user_post) { create(:post, user_id: another_user.id) }

      it "returns 200 and locks post when try to lock login user's unlocked post" do
        expect(Post.find(post.id).is_locked).to eq(false)

        put v1_post_changeLock_path(post.id), headers: headers
        expect(Post.find(post.id).is_locked).to eq(true)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 200 and unlocks post when try to unlock login user's locked post" do
        Post.find(post.id).update(is_locked: true)
        expect(Post.find(post.id).is_locked).to eq(true)

        put v1_post_changeLock_path(post.id), headers: headers
        expect(Post.find(post.id).is_locked).to eq(false)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 400 when try to lock not login user's unlocked post" do
        expect(Post.find(another_user_post.id).is_locked).to eq(false)

        put v1_post_changeLock_path(another_user_post.id), headers: headers
        expect(Post.find(another_user_post.id).is_locked).to eq(false)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end

      it "returns 400 when try to unlock not login user's locked post" do
        Post.find(another_user_post.id).update(is_locked: true)
        expect(Post.find(another_user_post.id).is_locked).to eq(true)

        put v1_post_changeLock_path(another_user_post.id), headers: headers
        expect(Post.find(another_user_post.id).is_locked).to eq(true)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end
    end
  end

  describe "POST /v1/posts/:id/replies - v1/posts#create_replies - Create reply" do
    context "when client doesn't have token" do
      before do
        create(:icon)
      end

      let(:user)      { create(:user) }
      let(:user_post) { create(:post, user_id: user.id) }

      it "returns 401" do
        post v1_post_replies_path(user_post.id)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user)   { create(:user) }
      let(:headers)       { client_user.create_new_auth_token }
      let!(:replied_post) { create(:post, user_id: client_user.id) }
      let(:params) do
        {
          content: 'Hello!',
          image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.png"), "image/png"),
          is_locked: true,
        }
      end

      context "when try to reply to current_user's post with valid post in body" do
        it 'returns 200 and create post and tree_paths' do
          expect do
            post v1_post_replies_path(replied_post.id), params: params, headers: headers
          end.to change(Post, :count).by(1).and change(TreePath, :count).by(2)

          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          reply_post = Post.order(created_at: :desc).limit(1)[0]
          expect(reply_post.user_id).to eq(client_user.id)
          expect(reply_post.content).to eq('Hello!')
          expect(reply_post.is_locked).to eq(true)
          expect(Icon.all.any? { |icon| reply_post.icon_id == icon.id }).to be_truthy

          expect(TreePath.where(ancestor: reply_post.id, descendant: reply_post.id, depth: 0)).to exist
          expect(TreePath.where(ancestor: replied_post.id, descendant: reply_post.id, depth: 1)).to exist
        end
      end

      context "when try to reply to current_user's post with invalid post in body" do
        it "returns 400 and doesn't create post and tree_path" do
          params = {
            content: '',
            image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.png"), "image/png"),
            is_locked: true,
          }
          replied_post = create(:post, user_id: client_user.id)
          expect do
            post v1_post_replies_path(replied_post.id), params: params, headers: headers
          end.to change(Post, :count).by(0).and change(TreePath, :count).by(0)
          expect(response).to have_http_status(400)
          expect(JSON.parse(response.body)["content"]).to include("can't be blank")
        end
      end

      context "when try to reply to current_user's post that it replied once before" do
        let(:replied_post) { create(:post, user_id: client_user.id) }

        it 'returns 200 and create post and tree_path' do
          post v1_post_replies_path(replied_post.id), params: params, headers: headers
          first_reply_post = Post.order(created_at: :desc).limit(1)[0]

          expect do
            post v1_post_replies_path(first_reply_post.id), params: params, headers: headers
          end.to change(Post, :count).by(1).and change(TreePath, :count).by(3)

          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          second_reply_post = Post.order(created_at: :desc).limit(1)[0]

          expect(TreePath.where(ancestor: second_reply_post.id, descendant: second_reply_post.id, depth: 0)).to exist
          expect(TreePath.where(ancestor: first_reply_post.id, descendant: second_reply_post.id, depth: 1)).to exist
          expect(TreePath.where(ancestor: replied_post.id, descendant: second_reply_post.id, depth: 2)).to exist
        end
      end

      context "when try to reply to current_user's post that it has two series of replies" do
        let(:replied_post) { create(:post, user_id: client_user.id) }

        it 'returns 200 and create post and tree_path' do
          post v1_post_replies_path(replied_post.id), params: params, headers: headers
          first_reply_post = Post.order(created_at: :desc).limit(1)[0]
          post v1_post_replies_path(first_reply_post.id), params: params, headers: headers
          second_reply_post = Post.order(created_at: :desc).limit(1)[0]

          expect do
            post v1_post_replies_path(second_reply_post.id), params: params, headers: headers
          end.to change(Post, :count).by(1).and change(TreePath, :count).by(4)

          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          third_reply_post = Post.order(created_at: :desc).limit(1)[0]

          expect(TreePath.where(ancestor: third_reply_post.id, descendant: third_reply_post.id, depth: 0)).to exist
          expect(TreePath.where(ancestor: second_reply_post.id, descendant: third_reply_post.id, depth: 1)).to exist
          expect(TreePath.where(ancestor: first_reply_post.id, descendant: third_reply_post.id, depth: 2)).to exist
          expect(TreePath.where(ancestor: replied_post.id, descendant: third_reply_post.id, depth: 3)).to exist
        end
      end

      context "when try to reply to follower's post" do
        let(:follow_user)       { create_follow_user(client_user) }
        let!(:follow_user_post) { create(:post, user_id: follow_user.id) }

        it 'returns 200 and create post and tree_path' do
          expect do
            post v1_post_replies_path(follow_user_post.id), params: params, headers: headers
          end.to change(Post, :count).by(1).and change(TreePath, :count).by(2)

          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          reply_post = Post.order(created_at: :desc).limit(1)[0]

          expect(TreePath.where(ancestor: reply_post.id, descendant: reply_post.id, depth: 0)).to exist
          expect(TreePath.where(ancestor: follow_user_post.id, descendant: reply_post.id, depth: 1)).to exist
        end
      end

      context "when try to reply to not follower's post" do
        let(:non_following_user)       { create(:user) }
        let!(:non_following_user_post) { create(:post, user_id: non_following_user.id) }

        it "returns 400 and doesn't create post and tree_path" do
          expect do
            post v1_post_replies_path(non_following_user_post.id), params: params, headers: headers
          end.to change(Post, :count).by(0).and change(TreePath, :count).by(0)

          expect(response).to have_http_status(400)
          expect(response.message).to include('Bad Request')
          expect(JSON.parse(response.body)['errors']['title']).to include('リプライ対象外の投稿です')
        end
      end

      context "when try to reply to non existent post" do
        let(:non_existent_post_id) { get_non_existent_post_id }

        it "returns 400 and doesn't create post and tree_path" do
          expect do
            post v1_post_replies_path(non_existent_post_id), params: params, headers: headers
          end.to change(Post, :count).by(0).and change(TreePath, :count).by(0)

          expect(response).to have_http_status(400)
          expect(response.message).to include('Bad Request')
          expect(JSON.parse(response.body)['errors']['title']).to include('投稿が存在しません')
        end
      end
    end
  end

  describe "GET /v1/likes - v1/posts#index_liked_posts - Get liked posts" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_liked_posts_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user)          { create(:user) }
      let(:client_user_headers)  { client_user.create_new_auth_token }
      let(:follower1)            { create_follow_user(client_user) }
      let(:follower1_headers)    { follower1.create_new_auth_token }
      let(:follower2)            { create_follow_user(client_user) }
      let(:follower2_headers)    { follower2.create_new_auth_token }
      let(:non_follower)         { create_follow_user(follower2) }
      let(:non_follower_headers) { non_follower.create_new_auth_token }

      context "when client has liked 3 client posts whose num of likes are 1 or 2 and num of replies are 0 or 1 or 2 and
       liked 4 followers's post whose num of replies are 0 or 1 or 2" do
        let!(:client_post_1liked_0reply)             { create(:post, user_id: client_user.id) }
        let!(:client_post_2liked_1reply)             { create(:post, user_id: client_user.id) }
        let!(:client_post_1liked_2reply)             { create(:post, user_id: client_user.id) }

        let!(:follower1_post_0reply)                 { create(:post, user_id: follower1.id) }
        let!(:follower1_post_1reply)                 { create(:post, user_id: follower1.id) }
        let!(:follower2_post_2reply)                 { create(:post, user_id: follower2.id) }
        let!(:follower2_post_1reply_by_non_follower) { create(:post, user_id: follower2.id) }

        let(:params) do
          {
            content: 'Hello!',
            image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.png"), "image/png"),
            is_locked: true,
          }
        end

        before do
          post v1_post_likes_path(client_post_1liked_2reply.id),             headers: client_user_headers
          post v1_post_likes_path(follower2_post_2reply.id),                 headers: client_user_headers
          post v1_post_likes_path(follower1_post_0reply.id),                 headers: client_user_headers
          post v1_post_likes_path(client_post_1liked_0reply.id),             headers: client_user_headers
          post v1_post_likes_path(client_post_2liked_1reply.id),             headers: follower1_headers
          post v1_post_likes_path(follower1_post_1reply.id),                 headers: client_user_headers
          post v1_post_likes_path(client_post_2liked_1reply.id),             headers: client_user_headers
          post v1_post_likes_path(follower2_post_1reply_by_non_follower.id), headers: client_user_headers

          post v1_post_replies_path(client_post_2liked_1reply.id),             params: params, headers: client_user_headers
          post v1_post_replies_path(client_post_1liked_2reply.id),             params: params, headers: follower1_headers
          post v1_post_replies_path(client_post_1liked_2reply.id),             params: params, headers: follower2_headers
          post v1_post_replies_path(follower1_post_1reply.id),                 params: params, headers: client_user_headers
          post v1_post_replies_path(follower2_post_2reply.id),                 params: params, headers: client_user_headers
          post v1_post_replies_path(follower2_post_2reply.id),                 params: params, headers: follower2_headers
          post v1_post_replies_path(follower2_post_1reply_by_non_follower.id), params: params, headers: non_follower_headers
        end

        it "returns 200 and 7 formatted liked posts in descending order for time client liked" do
          get v1_liked_posts_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(7)

          expect(response_body[0][:follower_post].length).to eq(11)
          expect(response_body[1][:current_user_post].length).to eq(14)
          expect(response_body[2][:follower_post].length).to eq(11)
          expect(response_body[3][:current_user_post].length).to eq(14)
          expect(response_body[4][:follower_post].length).to eq(11)
          expect(response_body[5][:follower_post].length).to eq(11)
          expect(response_body[6][:current_user_post].length).to eq(14)

          expect(response_body[0][:follower_post]).to include(
            id: follower2_post_1reply_by_non_follower.id,
            content: follower2_post_1reply_by_non_follower.content,
            image: follower2_post_1reply_by_non_follower.image.url,
            is_locked: follower2_post_1reply_by_non_follower.is_locked,
            icon_url: follower2_post_1reply_by_non_follower.icon.image.url,
            replies: 0,
            is_reply: false,
            is_liked_by_current_user: true,
          )
          expect(response_body[0][:follower_post]).to include(
            :deleted_at,
            :created_at,
            :updated_at,
          )
          expect(response_body[1][:current_user_post]).to include(
            id: client_post_2liked_1reply.id,
            content: client_post_2liked_1reply.content,
            image: client_post_2liked_1reply.image.url,
            is_locked: client_post_2liked_1reply.is_locked,
            icon_url: client_user.image.url,
            likes: 2,
            replies: 1,
            is_reply: false,
            username: client_user.username,
            userid: client_user.userid,
            is_liked_by_current_user: true,
          )
          expect(response_body[1][:current_user_post]).to include(
            :deleted_at,
            :created_at,
            :updated_at,
          )

          expect(response_body[2][:follower_post]).to include(
            id: follower1_post_1reply.id,
            replies: 1,
          )
          expect(response_body[3][:current_user_post]).to include(
            id: client_post_1liked_0reply.id,
            likes: 1,
            replies: 0,
          )
          expect(response_body[4][:follower_post]).to include(
            id: follower1_post_0reply.id,
            replies: 0,
          )
          expect(response_body[5][:follower_post]).to include(
            id: follower2_post_2reply.id,
            replies: 2,
          )
          expect(response_body[6][:current_user_post]).to include(
            id: client_post_1liked_2reply.id,
            likes: 1,
            replies: 2,
          )
        end
      end

      context "when client has liked 1 follower's post that replied by non-follower of client" do
        let!(:follower2_post_1reply_by_non_follower) { create(:post, user_id: follower2.id) }
        let(:params) do
          {
            content: 'Hello!',
            image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.png"), "image/png"),
            is_locked: true,
          }
        end

        before do
          post v1_post_likes_path(follower2_post_1reply_by_non_follower.id), headers: client_user_headers
          post v1_post_replies_path(follower2_post_1reply_by_non_follower.id), params: params, headers: non_follower_headers
        end

        it "returns 200 and formatted liked posts" do
          get v1_liked_posts_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(1)
          expect(response_body[0][:follower_post].length).to eq(11)
          expect(response_body[0][:follower_post]).to include(
            id: follower2_post_1reply_by_non_follower.id,
            content: follower2_post_1reply_by_non_follower.content,
            image: follower2_post_1reply_by_non_follower.image.url,
            is_locked: follower2_post_1reply_by_non_follower.is_locked,
            icon_url: follower2_post_1reply_by_non_follower.icon.image.url,
            replies: 0,
            is_reply: false,
            is_liked_by_current_user: true,
          )
          expect(response_body[0][:follower_post]).to include(
            :deleted_at,
            :created_at,
            :updated_at,
          )
        end
      end

      context 'when client has liked a post which is a reply of follower' do
        let!(:client_replied_post) { create(:post, user_id: client_user.id) }
        let(:params) do
          {
            content: 'Hello!',
            image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.png"), "image/png"),
            is_locked: true,
          }
        end

        before do
          post v1_post_replies_path(client_replied_post.id), params: params, headers: follower1_headers
          follower1_reply = Post.order(created_at: :desc).limit(1)[0]
          post v1_post_likes_path(follower1_reply.id), headers: client_user_headers
        end

        it 'returns 200 and return a post' do
          get v1_liked_posts_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          follower1_reply = Post.order(created_at: :desc).limit(1)[0]
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(1)
          expect(response_body[0][:follower_post].length).to eq(11)
          expect(response_body[0][:follower_post]).to include(
            id: follower1_reply.id,
            content: follower1_reply.content,
            image: follower1_reply.image.url,
            is_locked: follower1_reply.is_locked,
            icon_url: follower1_reply.icon.image.url,
            replies: 0,
            is_reply: true,
            is_liked_by_current_user: true,
          )
          expect(response_body[0][:follower_post]).to include(
            :deleted_at,
            :created_at,
            :updated_at,
          )
        end
      end

      context "when client hasn't liked posts" do
        it 'returns 200 and no posts' do
          get v1_liked_posts_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(0)
        end
      end
    end
  end

  describe "GET /v1/posts/me_and_followers
  - v1/posts#index_me_and_followers_posts
  - Get current user and follower posts" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_me_and_followers_posts_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user)          { create(:user) }
      let(:client_user_headers)  { client_user.create_new_auth_token }
      let(:follower1)            { create_follow_user(client_user) }
      let(:follower1_headers)    { follower1.create_new_auth_token }
      let(:follower2)            { create_follow_user(client_user) }
      let(:non_follower)         { create(:user) }
      let(:non_follower_headers) { non_follower.create_new_auth_token }

      context "when client's, followers's and non-followers's posts are exist" do
        # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
        # 各々のユーザの投稿について、リプライを持つものと持たないものを作成すること
        # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
        let!(:client_post_without_reply)       { create(:post, user_id: client_user.id) }
        let!(:client_post_with_reply)          { create(:post, user_id: client_user.id) }
        let!(:follower1_post_without_reply)    { create(:post, user_id: follower1.id) }
        let!(:follower2_post_with_reply)       { create(:post, user_id: follower2.id) }
        let!(:non_follower_post_without_reply) { create(:post, user_id: non_follower.id) }
        let!(:non_follower_post_with_reply)    { create(:post, user_id: non_follower.id) }

        let(:params) do
          {
            content: 'Hello!',
            image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.png"), "image/png"),
            is_locked: true,
          }
        end

        before do
          post v1_post_replies_path(follower2_post_with_reply.id),    params: params, headers: client_user_headers
          post v1_post_replies_path(client_post_with_reply.id),       params: params, headers: client_user_headers
          post v1_post_replies_path(non_follower_post_with_reply.id), params: params, headers: non_follower_headers

          post v1_post_likes_path(client_post_with_reply.id), headers: client_user_headers
          post v1_post_likes_path(client_post_with_reply.id), headers: follower1_headers
        end

        it "return 200 and client's and followers's sorted posts" do
          get v1_me_and_followers_posts_path, headers: client_user_headers

          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(4)

          # ソートが正しく実装されているかテスト
          expect(response_body[0][:follower_post]).to have_id(follower2_post_with_reply.id)
          expect(response_body[1][:follower_post]).to have_id(follower1_post_without_reply.id)
          expect(response_body[2][:current_user_post]).to have_id(client_post_with_reply.id)
          expect(response_body[3][:current_user_post]).to have_id(client_post_without_reply.id)

          expect(response_body[0][:follower_post].length).to eq(11)
          expect(response_body[1][:follower_post].length).to eq(11)
          expect(response_body[2][:current_user_post].length).to eq(14)
          expect(response_body[3][:current_user_post].length).to eq(14)

          expect(response_body[2][:current_user_post]).to include(
            id: client_post_with_reply.id,
            content: client_post_with_reply.content,
            image: client_post_with_reply.image.url,
            is_locked: client_post_with_reply.is_locked,
            icon_url: client_user.image.url,
            likes: 2,
            replies: 1,
            is_liked_by_current_user: true,
            username: client_user.username,
            userid: client_user.userid,
            is_reply: false,
          )
          expect(response_body[2][:current_user_post]).to include(
            :deleted_at,
            :created_at,
            :updated_at,
          )
          expect(response_body[1][:follower_post]).to include(
            id: follower1_post_without_reply.id,
            content: follower1_post_without_reply.content,
            image: follower1_post_without_reply.image.url,
            is_locked: follower1_post_without_reply.is_locked,
            icon_url: follower1_post_without_reply.icon.image.url,
            replies: 0,
            is_liked_by_current_user: false,
            is_reply: false,
          )
          expect(response_body[1][:follower_post]).to include(
            :deleted_at,
            :created_at,
            :updated_at,
          )
        end
      end

      context "when client's post is exist" do
        let!(:client_post_without_reply) { create(:post, user_id: client_user.id) }

        it "returns 200 and client's post" do
          get v1_me_and_followers_posts_path, headers: client_user_headers

          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(1)
          expect(response_body[0][:current_user_post].length).to eq(14)
          expect(response_body[0][:current_user_post]).to include(
            id: client_post_without_reply.id,
            content: client_post_without_reply.content,
            image: client_post_without_reply.image.url,
            is_locked: client_post_without_reply.is_locked,
            icon_url: client_user.image.url,
            likes: 0,
            replies: 0,
            is_liked_by_current_user: false,
            username: client_user.username,
            userid: client_user.userid,
            is_reply: false,
          )
          expect(response_body[0][:current_user_post]).to include(
            :deleted_at,
            :created_at,
            :updated_at,
          )
        end
      end

      context "when follower's post is exist" do
        let!(:follower1_post_without_reply) { create(:post, user_id: follower1.id) }

        it "returns 200 and follower's post" do
          get v1_me_and_followers_posts_path, headers: client_user_headers

          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(1)
          expect(response_body[0][:follower_post].length).to eq(11)
          expect(response_body[0][:follower_post]).to include(
            id: follower1_post_without_reply.id,
            content: follower1_post_without_reply.content,
            image: follower1_post_without_reply.image.url,
            is_locked: follower1_post_without_reply.is_locked,
            icon_url: follower1_post_without_reply.icon.image.url,
            replies: 0,
            is_liked_by_current_user: false,
            is_reply: false,
          )
          expect(response_body[0][:follower_post]).to include(
            :deleted_at,
            :created_at,
            :updated_at,
          )
        end
      end

      context "when non-follower's post is exist" do
        let!(:non_follower_post_without_reply) { create(:post, user_id: non_follower.id) }

        it 'returns 200 and no posts' do
          get v1_me_and_followers_posts_path, headers: client_user_headers

          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(0)
        end
      end

      context "when logically deleted client's post is exist" do
        let!(:client_post_without_reply) { create(:post, user_id: client_user.id) }

        before do
          delete v1_post_path(client_post_without_reply.id), headers: client_user_headers
        end

        it 'returns 200 and no posts' do
          get v1_me_and_followers_posts_path, headers: client_user_headers

          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(0)
        end
      end

      context "when posts aren't exist" do
        it 'retruns 200 and no posts' do
          get v1_me_and_followers_posts_path, headers: client_user_headers

          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(0)
        end
      end
    end
  end

  describe "GET /v1/posts/me - v1/posts#index_current_user_posts - Get current user's posts" do
    # ***********************************************************
    # 【注意点】
    # データのフォーマットに以下の2メソッドを使用する前提でテストをしている。
    # -format_current_user_post(current_user)
    # -format_follower_post(current_user)
    #
    # これら以外のメソッドを使用するように変更する場合は、
    # 実施するテストを1から考え直すこと。
    # ***********************************************************

    context "when client doesn't have token" do
      it "returns 401" do
        get v1_current_user_posts_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user)         { create(:user) }
      let(:client_user_headers) { client_user.create_new_auth_token }

      context "when client has own posts(not replies) and reply" do
        let!(:client_post1) { create(:post, user_id: client_user.id) }
        let!(:client_reply) { create_reply_to_prams_post(client_user, client_post1) }
        let!(:client_post2) { create(:post, user_id: client_user.id) }

        it "returns 200 and 3 formatted posts" do
          get v1_current_user_posts_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(3)
          expect(response_body[0][:current_user_post]).to have_id(client_post2.id)
          expect(response_body[1][:current_user_post]).to have_id(client_reply.id)
          expect(response_body[2][:current_user_post]).to have_id(client_post1.id)
        end
      end

      context "when client has a post" do
        let!(:client_post) { create(:post, user_id: client_user.id) }

        it "returns 200 and a formatted post" do
          get v1_current_user_posts_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body)
          expect(response_body.length).to eq(1)
        end
      end

      context "when client has no posts" do
        it "returns 200 and no posts" do
          get v1_current_user_posts_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body)
          expect(response_body.length).to eq(0)
        end
      end
    end
  end

  describe "GET /v1/posts/:id/threads - v1/posts#index_threads - Get thread of post of current user or followers" do
    # ***********************************************************
    # 【注意点】
    # ◆その1
    # データのフォーマットに以下のモデルメソッド2つを使用する前提でテストをしている。
    # -format_current_user_post(current_user)
    # -format_follower_post(current_user)
    #
    # これら以外のメソッドを使用するように変更する場合は、
    # 実施するテストを1から考え直すこと。

    # ◆その2
    # 投稿のスレッドを取得する際に使用するメソッドとして、
    # 以下4つのクラスメソッドを利用している。
    # -check_status_of_current_post
    # -get_current_according_to_status_of_current_post
    # -get_parent_of_current_post
    # -get_children_of_current_post
    # これらのメソッドに関しては、このスペックのみでテストをする。
    # 他のAPIでもここでテストをしたメソッドを使い回すことがあるため、
    # その際にメソッドが編集された際にはこちらのテストを修正すること。
    # ***********************************************************

    # *******************************************************************************
    # 【仕様について補足】
    # params[:post_id]に紐づく投稿が、非相互フォロワーのものであった場合、
    # 親や子の投稿の情報は返さない。
    #
    # params[:post_id]に紐づく投稿が、カレントユーザまたは相互フォロワーのものであった場合でかつ、
    # 親の投稿が非相互フォロワーのものであった場合は、parent: not_follower_postを返し、
    # 子の投稿が複数でかつ非相互フォロワーのものを含む場合は、非相互フォロワーに関連する情報を返さず、
    # 子の投稿が単数でかつ非相互フォロワーのものである場合は、children: not_existを返し、
    # 子の投稿が削除済でかつ非相互フォロワーのものである場合は、children: not_existを返す。
    # *******************************************************************************

    context "when client doesn't have token" do
      before do
        create(:icon)
      end

      let(:client_user)      { create(:user) }
      let(:client_user_post) { create(:post, user_id: client_user.id) }

      it "returns 401" do
        get v1_post_threads_path(client_user_post.id)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user)         { create(:user) }
      let(:client_user_headers) { client_user.create_new_auth_token }
      let(:follower)            { create_follow_user(client_user) }
      let(:not_follower)        { create_follow_user(follower) }

      context "when no posts related to params[:post_id]" do
        let(:non_existent_post_id) { get_non_existent_post_id }

        it 'retuns 200 and current: not_exist' do
          get v1_post_threads_path(non_existent_post_id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(1)
          expect(response_body[:current]).to eq(not_exist: nil)
        end
      end

      context "when post related to params[:post_id] is deleted" do
        let!(:deleted_post) { create(:post, user_id: client_user.id) }

        before do
          delete v1_post_path(deleted_post.id), headers: client_user_headers
        end

        it 'returns 200 and current: deleted' do
          get v1_post_threads_path(deleted_post.id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(1)
          expect(response_body[:current]).to eq(deleted: nil)
        end
      end

      context "when post related to params[:post_id] is exist and posted by not follower" do
        let!(:current_post_of_not_follower) { create(:post, user_id: not_follower.id) }

        it 'returns 200 and current: not_follower_post' do
          get v1_post_threads_path(current_post_of_not_follower.id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(1)
          expect(response_body[:current]).to eq(not_follower_post: nil)
        end
      end

      context "when post related to params[:post_id] is exist and posted by current user
      and the post has 1 parent post of current user
      and the post has 2 child posts of current user and follower" do
        let!(:parent_post_of_client_user)  { create(:post, user_id: client_user.id) }
        let!(:current_post_of_client_user) { create_reply_to_prams_post(client_user, parent_post_of_client_user) }
        let!(:child_post_of_client_user)   { create_reply_to_prams_post(client_user, current_post_of_client_user) }
        let!(:child_post_of_follower)      { create_reply_to_prams_post(follower, current_post_of_client_user) }

        it 'returns 200 and thread' do
          get v1_post_threads_path(current_post_of_client_user.id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(3)

          expect(response_body[:parent][:current_user_post]).to have_id(parent_post_of_client_user.id)
          expect(response_body[:parent][:current_user_post].length).to eq(14)

          expect(response_body[:current][:current_user_post]).to have_id(current_post_of_client_user.id)
          expect(response_body[:current][:current_user_post].length).to eq(14)

          expect(response_body[:children].length).to eq(2)
          expect(response_body[:children][0][:follower_post].length).to eq(11)
          expect(response_body[:children][1][:current_user_post].length).to eq(14)
          expect(response_body[:children][0][:follower_post]).to have_id(child_post_of_follower.id)
          expect(response_body[:children][1][:current_user_post]).to have_id(child_post_of_client_user.id)
        end
      end

      context "when post related to params[:post_id] is exist and posted by current user
      and the post has 1 parent post of follower
      and the post has 2 child posts of current user" do
        let!(:parent_post_of_follower)     { create(:post, user_id: follower.id) }
        let!(:current_post_of_client_user) { create_reply_to_prams_post(client_user, parent_post_of_follower) }
        let!(:child_post1_of_client_user)  { create_reply_to_prams_post(client_user, current_post_of_client_user) }
        let!(:child_post2_of_client_user)  { create_reply_to_prams_post(client_user, current_post_of_client_user) }

        it 'returns 200 and thread' do
          get v1_post_threads_path(current_post_of_client_user.id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(3)
          expect(response_body[:parent][:follower_post]).to have_id(parent_post_of_follower.id)
          expect(response_body[:parent][:follower_post].length).to eq(11)

          expect(response_body[:current][:current_user_post]).to have_id(current_post_of_client_user.id)
          expect(response_body[:current][:current_user_post].length).to eq(14)

          expect(response_body[:children].length).to eq(2)
          expect(response_body[:children][0][:current_user_post].length).to eq(14)
          expect(response_body[:children][1][:current_user_post].length).to eq(14)
          expect(response_body[:children][0][:current_user_post]).to have_id(child_post2_of_client_user.id)
          expect(response_body[:children][1][:current_user_post]).to have_id(child_post1_of_client_user.id)
        end
      end

      context "when post related to params[:post_id] is exist and posted by current user
      and the post doesn't have parent post
      and the post has 2 child posts of follower" do
        let!(:current_post_of_client_user) { create(:post, user_id: client_user.id) }
        let!(:child_post1_of_follower) { create_reply_to_prams_post(follower, current_post_of_client_user) }
        let!(:child_post2_of_follower) { create_reply_to_prams_post(follower, current_post_of_client_user) }

        it 'returns 200 and thread' do
          get v1_post_threads_path(current_post_of_client_user.id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(3)

          expect(response_body[:parent][:not_exist]).to eq(nil)

          expect(response_body[:current][:current_user_post]).to have_id(current_post_of_client_user.id)
          expect(response_body[:current][:current_user_post].length).to eq(14)

          expect(response_body[:children].length).to eq(2)
          expect(response_body[:children][0][:follower_post].length).to eq(11)
          expect(response_body[:children][1][:follower_post].length).to eq(11)
          expect(response_body[:children][0][:follower_post]).to have_id(child_post2_of_follower.id)
          expect(response_body[:children][1][:follower_post]).to have_id(child_post1_of_follower.id)
        end
      end

      context "when post related to params[:post_id] is exist and posted by current user
      and the post has 1 deleted parent post of current user
      and the post doesn't have child post" do
        let!(:deleted_parent_post_of_client_user) { create(:post, user_id: client_user.id) }
        let!(:current_post_of_client_user)        { create_reply_to_prams_post(client_user, deleted_parent_post_of_client_user) }

        before do
          delete v1_post_path(deleted_parent_post_of_client_user.id), headers: client_user_headers
        end

        it 'returns 200 and thread' do
          get v1_post_threads_path(current_post_of_client_user.id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(3)

          expect(response_body[:parent][:deleted]).to eq(nil)

          expect(response_body[:current][:current_user_post]).to have_id(current_post_of_client_user.id)
          expect(response_body[:current][:current_user_post].length).to eq(14)

          expect(response_body[:children].length).to eq(1)
          expect(response_body[:children][0][:not_exist]).to eq(nil)
        end
      end

      context "when post related to params[:post_id] is exist and posted by current user
      and the post doesn't have parent post
      and the post has 1 deleted child post of client user or follower" do
        let!(:current_post_of_client_user) { create(:post, user_id: client_user.id) }
        let!(:deleted_child_post_of_follower) { create_reply_to_prams_post(follower, current_post_of_client_user) }

        it 'returns 200 and thread' do
          get v1_post_threads_path(current_post_of_client_user.id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(3)

          expect(response_body[:parent][:not_exist]).to eq(nil)

          expect(response_body[:current][:current_user_post]).to have_id(current_post_of_client_user.id)
          expect(response_body[:current][:current_user_post].length).to eq(14)

          expect(response_body[:children].length).to eq(1)
          expect(response_body[:children][0][:deleted]).to eq(nil)
        end
      end

      context "when post related to params[:post_id] is exist and posted by follower
      and the post has 1 parent post of not follower of current user
      and the post has 2 child posts of not follower of current user" do
        let!(:parent_post_of_not_follower) { create(:post, user_id: not_follower.id) }
        let!(:current_post_of_follower) do
          create_reply_to_prams_post(follower, parent_post_of_not_follower)
        end
        let!(:child_post1_of_not_follower) do
          create_reply_to_prams_post(not_follower, current_post_of_follower)
        end
        let!(:child_post2_of_not_follower) do
          create_reply_to_prams_post(not_follower, current_post_of_follower)
        end

        it 'returns 200 and thread' do
          get v1_post_threads_path(current_post_of_follower.id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(3)

          expect(response_body[:parent][:not_follower_post]).to eq(nil)

          expect(response_body[:current][:follower_post]).to have_id(current_post_of_follower.id)
          expect(response_body[:current][:follower_post].length).to eq(11)

          expect(response_body[:children].length).to eq(1)
          expect(response_body[:children][0][:not_exist]).to eq(nil)
        end
      end

      context "when post related to params[:post_id] is exist and posted by follower
      and the post doesn't have parent post
      and the post has 2 child post of current user and not follower of current user" do
        let!(:current_post_of_follower) { create(:post, user_id: follower.id) }
        let!(:child_post_of_not_follower) do
          create_reply_to_prams_post(not_follower, current_post_of_follower)
        end
        let!(:child_post_of_current_user) { create_reply_to_prams_post(client_user, current_post_of_follower) }

        it 'returns 200 and thread' do
          get v1_post_threads_path(current_post_of_follower.id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(3)

          expect(response_body[:parent][:not_follower_post]).to eq(nil)

          expect(response_body[:current][:follower_post]).to have_id(current_post_of_follower.id)
          expect(response_body[:current][:follower_post].length).to eq(11)

          expect(response_body[:children].length).to eq(1)
          expect(response_body[:children][0][:current_user_post]).to have_id(child_post_of_current_user.id)
          expect(response_body[:children][0][:current_user_post].length).to eq(14)
        end
      end

      context "when post related to params[:post_id] is exist and posted by follower
      and the post doesn't have parent post
      and the post has 1 child post of follower" do
        let!(:current_post_of_follower) { create(:post, user_id: follower.id) }
        let!(:child_post_of_follower)   { create_reply_to_prams_post(follower, current_post_of_follower) }

        it 'returns 200 and thread' do
          get v1_post_threads_path(current_post_of_follower.id), headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(3)

          expect(response_body[:parent][:not_follower_post]).to eq(nil)

          expect(response_body[:current][:follower_post]).to have_id(current_post_of_follower.id)
          expect(response_body[:current][:follower_post].length).to eq(11)

          expect(response_body[:children].length).to eq(1)
          expect(response_body[:children][0][:follower_post]).to have_id(child_post_of_follower.id)
          expect(response_body[:children][0][:follower_post].length).to eq(11)
        end
      end
    end
  end

  describe "GET /v1/replies - v1/posts#index_replies - Get replies" do
    # *******************************************************************
    # 【注意点】
    # データのフォーマットに以下のモデルメソッド2つを使用する前提でテストをしている。
    # -format_current_user_post(current_user)
    # -format_follower_post(current_user)
    #
    # これら以外のメソッドを使用するように変更する場合は、
    # 実施するテストを1から考え直すこと。
    # *******************************************************************

    context "when client doesn't have token" do
      it "returns 401" do
        get v1_replies_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user)          { create(:user) }
      let(:client_user_headers)  { client_user.create_new_auth_token }
      let(:follower)             { create_follow_user(client_user) }
      let(:follower_headers)     { follower.create_new_auth_token }
      # not_follower: 投稿作成時はフォロワーだったが、投稿作成後にフォローを解除したユーザ
      let(:not_follower)         { create_follow_user(client_user) }
      let(:not_follower_headers) { not_follower.create_new_auth_token }

      context "case1, 2, 4, 6, 8" do
        let!(:case1_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case1_follower_post_1)     { create_reply_to_prams_post(follower, case1_current_user_post_1) }

        let!(:case2_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case2_follower_post_1)     { create_reply_to_prams_post(follower, case2_current_user_post_1) }
        let!(:case2_follower_post_2)     { create_reply_to_prams_post(follower, case2_current_user_post_1) }

        let!(:case4_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case4_follower_post_1)     { create_reply_to_prams_post(follower, case4_current_user_post_1) }

        let!(:case6_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case6_not_follower_post_1) { create_reply_to_prams_post(not_follower, case6_current_user_post_1) }

        let!(:case8_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case8_follower_post_1)     { create_reply_to_prams_post(follower, case8_current_user_post_1) }
        let!(:case8_current_user_post_2) { create_reply_to_prams_post(client_user, case8_follower_post_1) }

        before do
          delete v1_post_path(case4_follower_post_1.id), headers: follower_headers
          delete v1_follower_path(client_user.userid),   headers: not_follower_headers
        end

        it 'returns 200 and replies' do
          get v1_replies_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(3)
          expect(response_body[0][:current_user_post].length).to eq(14)
          expect(response_body[0][:current_user_post]).to have_id(case8_current_user_post_2.id)
          expect(response_body[1][:current_user_post].length).to eq(14)
          expect(response_body[1][:current_user_post]).to have_id(case2_current_user_post_1.id)
          expect(response_body[2][:current_user_post].length).to eq(14)
          expect(response_body[2][:current_user_post]).to have_id(case1_current_user_post_1.id)
        end
      end

      context "case3, 5, 7, 9" do
        let!(:case3_current_user_post_1) { create(:post, user_id: client_user.id) }

        let!(:case5_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case5_follower_post_1)     { create_reply_to_prams_post(follower, case5_current_user_post_1) }
        let!(:case5_follower_post_2)     { create_reply_to_prams_post(follower, case5_current_user_post_1) }

        let!(:case7_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case7_not_follower_post_1) { create_reply_to_prams_post(not_follower, case7_current_user_post_1) }
        let!(:case7_not_follower_post_2) { create_reply_to_prams_post(not_follower, case7_current_user_post_1) }

        let!(:case9_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case9_follower_post_1)     { create_reply_to_prams_post(follower, case9_current_user_post_1) }
        let!(:case9_current_user_post_2) { create_reply_to_prams_post(client_user, case9_follower_post_1) }
        let!(:case9_follower_post_2)     { create_reply_to_prams_post(follower, case9_current_user_post_2) }
        let!(:case9_current_user_post_3) { create_reply_to_prams_post(client_user, case9_follower_post_2) }

        before do
          delete v1_post_path(case5_follower_post_1.id),     headers: follower_headers
          delete v1_post_path(case5_follower_post_2.id),     headers: follower_headers
          delete v1_post_path(case9_current_user_post_3.id), headers: client_user_headers
          delete v1_follower_path(client_user.userid),       headers: not_follower_headers
        end

        it 'returns 200 and replies' do
          get v1_replies_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(1)
          expect(response_body[0][:current_user_post].length).to eq(14)
          expect(response_body[0][:current_user_post]).to have_id(case9_current_user_post_2.id)
        end
      end

      context "case10, 11, 12" do
        let!(:case10_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case10_follower_post_1)     { create_reply_to_prams_post(follower, case10_current_user_post_1) }
        let!(:case10_current_user_post_2) { create_reply_to_prams_post(client_user, case10_follower_post_1) }
        let!(:case10_current_user_post_3) { create_reply_to_prams_post(follower, case10_current_user_post_2) }

        let!(:case11_follower_post_1)     { create(:post, user_id: follower.id) }
        let!(:case11_current_user_post_1) { create_reply_to_prams_post(client_user, case11_follower_post_1) }
        let!(:case11_follower_post_2)     { create_reply_to_prams_post(follower, case11_current_user_post_1) }
        let!(:case11_current_user_post_2) { create_reply_to_prams_post(client_user, case11_follower_post_2) }
        let!(:case11_follower_post_3)     { create_reply_to_prams_post(follower, case11_current_user_post_2) }

        let!(:case12_follower_post_1)     { create(:post, user_id: follower.id) }
        let!(:case12_current_user_post_1) { create_reply_to_prams_post(client_user, case12_follower_post_1) }
        let!(:case12_follower_post_2)     { create_reply_to_prams_post(follower, case12_current_user_post_1) }
        let!(:case12_current_user_post_2) { create_reply_to_prams_post(client_user, case12_follower_post_2) }
        let!(:case12_follower_post_3)     { create_reply_to_prams_post(follower, case12_current_user_post_2) }
        let!(:case12_current_user_post_3) { create_reply_to_prams_post(client_user, case12_follower_post_3) }

        before do
          delete v1_post_path(case10_current_user_post_3.id), headers: client_user_headers
          delete v1_post_path(case11_current_user_post_1.id), headers: client_user_headers
          delete v1_post_path(case11_follower_post_2.id), headers: follower_headers
          delete v1_post_path(case11_current_user_post_2.id), headers: client_user_headers
          delete v1_post_path(case12_current_user_post_2.id), headers: client_user_headers
          delete v1_post_path(case12_current_user_post_3.id), headers: client_user_headers
        end

        it 'returns 200 and replies' do
          get v1_replies_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(2)
          expect(response_body[0][:current_user_post].length).to eq(14)
          expect(response_body[0][:current_user_post]).to have_id(case12_current_user_post_1.id)
          expect(response_body[1][:current_user_post].length).to eq(14)
          expect(response_body[1][:current_user_post]).to have_id(case10_current_user_post_2.id)
        end
      end

      context "13, 14" do
        let!(:case13_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case13_follower_post_1)     { create_reply_to_prams_post(follower, case13_current_user_post_1) }
        let!(:case13_current_user_post_2) { create_reply_to_prams_post(client_user, case13_follower_post_1) }

        let!(:case14_current_user_post_1) { create(:post, user_id: client_user.id) }
        let!(:case14_follower_post_1)     { create_reply_to_prams_post(follower, case14_current_user_post_1) }
        let!(:case14_current_user_post_2) { create_reply_to_prams_post(client_user, case14_follower_post_1) }

        before do
          delete v1_post_path(case13_current_user_post_2.id), headers: client_user_headers
          delete v1_post_path(case14_follower_post_1.id),     headers: follower_headers
          delete v1_post_path(case14_current_user_post_2.id), headers: client_user_headers
        end

        it 'returns 200 and replies' do
          get v1_replies_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(1)
          expect(response_body[0][:current_user_post].length).to eq(14)
          expect(response_body[0][:current_user_post]).to have_id(case13_current_user_post_1.id)
        end
      end

      context "when number of current user's posts is 1" do
        let!(:current_user_post) { create(:post, user_id: client_user.id) }
        let!(:follower_reply)    { create_reply_to_prams_post(follower, current_user_post) }

        it 'returns 200 and replies' do
          get v1_replies_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body.length).to eq(1)
          expect(response_body[0][:current_user_post].length).to eq(14)
          expect(response_body[0][:current_user_post]).to have_id(current_user_post.id)
        end
      end

      context "when number of current user's posts is 0" do
        it 'returns 200 and replies' do
          get v1_replies_path, headers: client_user_headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(0)
        end
      end
    end
  end

  describe "GET /v1/refract_candidate - v1/posts#index_refract_candidates - Get refract candidates" do
    # ************************************************************************
    # 【注意点】
    # データのフォーマットに以下のクラスメソッド2つを使用する前提でテストをしている。
    # -format_current_user_post(current_user)
    # -format_follower_post(current_user)
    #
    # これら以外のメソッドを使用するように変更する場合は、
    # 実施するテストを1から考え直すこと。
    # ************************************************************************

    context "when client doesn't have token" do
      it "returns 401" do
        get v1_post_refract_candidates_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token and has performed CurrentUserRefract record" do
      before do
        CurrentUserRefract.create(user_id: client_user.id, performed_refract: true)
      end

      let(:client_user)         { create(:user) }
      let(:client_user_headers) { client_user.create_new_auth_token }

      it 'returns 400' do
        expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 1
        expect(client_user.current_user_refracts.where(performed_refract: false).length).to eq 0
        get v1_post_refract_candidates_path, headers: client_user_headers
        expect(response).to have_http_status(403)
        expect(response.message).to include('Forbidden')
        expect(JSON.parse(response.body)['errors']['title']).to include('リフラクト機能を使用できません')
      end
    end

    context "when client has token and has not performed CurrentUserRefract record" do
      context 'case 1, 3, 11, 24, 25, 26, 27' do
        before do
          travel_to Time.zone.local(2021, 8, 15) do
            create(:icon)
            @client_user = create(:user)
            @follower = create_follow_user(@client_user)
            @not_follower = create_follow_user(@client_user)
            @client_user_headers = @client_user.create_new_auth_token
            @follower_headers = @follower.create_new_auth_token
            @not_follower_headers = @not_follower.create_new_auth_token
          end

          travel_to Time.zone.local(2021, 8, 21, 4, 30, 0o0) do
            @case3_11_follower_post = create(:post, user_id: @follower.id)

            @case24_not_follower_post1 = create(:post, user_id: @not_follower.id)
            @case24_current_user_post = create_reply_to_prams_post(@client_user, @case24_not_follower_post1)
            create_reply_to_prams_post(@not_follower, @case24_current_user_post) # case24_not_follower_post2

            @case25_current_user_post1 = create(:post, user_id: @client_user.id)
            @case25_follower_post1 = create_reply_to_prams_post(@follower, @case25_current_user_post1)
            @case25_current_user_post2 = create_reply_to_prams_post(@client_user, @case25_follower_post1)
            @case25_follower_post2 = create_reply_to_prams_post(@follower, @case25_current_user_post2)

            @case26_27_follower_post1 = create(:post, user_id: @follower.id)
            @case26_27_current_user_post1 = create_reply_to_prams_post(@client_user, @case26_27_follower_post1)
            @case26_follower_post2 = create_reply_to_prams_post(@follower, @case26_27_current_user_post1)
            @case27_follower_post2 = create_reply_to_prams_post(@follower, @case26_27_current_user_post1)
          end

          travel_to Time.zone.local(2021, 8, 21, 5, 30, 0o0) do
            CurrentUserRefract.create(user_id: @client_user.id, performed_refract: false)
            post   v1_post_likes_path(@case3_11_follower_post.id), headers: @client_user_headers
            delete v1_post_path(@case25_follower_post1.id),        headers: @follower_headers
            delete v1_post_path(@case25_follower_post2.id),        headers: @follower_headers
            delete v1_post_path(@case26_follower_post2.id),        headers: @follower_headers
            delete v1_post_path(@case27_follower_post2.id),        headers: @follower_headers
          end
        end

        it 'return 200 and refract candidates' do
          travel_to Time.zone.local(2021, 8, 22, 2, 0o0, 0o0) do
            delete v1_follower_path(@client_user.userid), headers: @not_follower_headers
          end

          travel_to Time.zone.local(2021, 8, 22, 3, 0o0, 0o0) do
            get v1_post_refract_candidates_path, headers: @client_user_headers
            expect(response).to have_http_status(200)
            expect(response.message).to include('OK')
            response_body = JSON.parse(response.body, symbolize_names: true)
            expect(response_body.length).to eq(1)
            expect(response_body[0][:reply][:current_user_post]).to have_id(@case26_27_current_user_post1.id)
            expect(response_body[0][:reply][:current_user_post].length).to eq(14)
          end
        end
      end

      context 'case 2, 4, 9, 10, 14, 15, 16, 17' do
        before do
          travel_to Time.zone.local(2021, 8, 14) do
            create(:icon)
            @client_user = create(:user)
            @follower = create_follow_user(@client_user)
            @client_user_headers = @client_user.create_new_auth_token
          end

          travel_to Time.zone.local(2021, 8, 14, 5, 30, 0o0) do
            CurrentUserRefract.create(user_id: @client_user.id, performed_refract: true)
            @case4_9_follower_post = create(:post, user_id: @follower.id)
            @case4_10_follower_post = create(:post, user_id: @follower.id)
          end

          travel_to Time.zone.local(2021, 8, 21, 5, 29, 59) do
            post v1_post_likes_path(@case4_10_follower_post.id), headers: @client_user_headers
            @case14_current_user_post = create(:post, user_id: @client_user.id)
            @case14_follower_post = create_reply_to_prams_post(@follower, @case14_current_user_post)
          end

          travel_to Time.zone.local(2021, 8, 21, 5, 30, 0o0) do
            CurrentUserRefract.create(user_id: @client_user.id, performed_refract: true)
            post v1_post_likes_path(@case4_9_follower_post.id), headers: @client_user_headers
          end

          travel_to Time.zone.local(2021, 8, 25) do
            @case17_current_user_post = create(:post, user_id: @client_user.id)
            @case17_follower_post1 = create_reply_to_prams_post(@follower, @case17_current_user_post)
            @case17_follower_post2 = create_reply_to_prams_post(@follower, @case17_follower_post1)
            @case17_follower_post1.update(is_locked: true)
          end

          travel_to Time.zone.local(2021, 8, 28, 5, 29, 59) do
            @case16_current_user_post = create(:post, user_id: @client_user.id)
            @case16_follower_post = create_reply_to_prams_post(@follower, @case16_current_user_post)
          end

          travel_to Time.zone.local(2021, 8, 28, 5, 30, 0o0) do
            CurrentUserRefract.create(user_id: @client_user.id, performed_refract: false)
            @case15_current_user_post = create(:post, user_id: @client_user.id)
            @case15_follower_post = create_reply_to_prams_post(@follower, @case15_current_user_post)
          end
        end

        it 'return 200 and sorted refract candidates' do
          travel_to Time.zone.local(2021, 8, 29) do
            client_user_headers = @client_user.create_new_auth_token
            get v1_post_refract_candidates_path, headers: client_user_headers
            expect(response).to have_http_status(200)
            expect(response.message).to include('OK')
            response_body = JSON.parse(response.body, symbolize_names: true)
            expect(response_body.length).to eq(2)
            expect(response_body[0][:reply][:follower_post]).to have_id(@case16_follower_post.id)
            expect(response_body[0][:reply][:follower_post].length).to eq(11)
            expect(response_body[1][:like][:follower_post]).to have_id(@case4_9_follower_post.id)
            expect(response_body[1][:like][:follower_post].length).to eq(11)
          end
        end
      end

      context 'case 2, 5, 6, 7, 8, 12, 13, 18, 19, 20, 21, 22, 23' do
        before do
          travel_to Time.zone.local(2021, 8, 14) do
            create(:icon)
            @client_user = create(:user)
            @follower = create_follow_user(@client_user)
            @client_user_headers = @client_user.create_new_auth_token
            @follower_headers = @follower.create_new_auth_token
          end

          travel_to Time.zone.local(2021, 8, 14, 3, 30, 0o0) do
            @case_20_21_follower_post1 = create(:post, user_id: @follower.id)
            @case_20_21_follower_post2 = create_reply_to_prams_post(@follower, @case_20_21_follower_post1)
            @case21_follower_post = create_reply_to_prams_post(@follower, @case_20_21_follower_post2)
          end

          travel_to Time.zone.local(2021, 8, 14, 5, 30, 0o0) do
            CurrentUserRefract.create(user_id: @client_user.id, performed_refract: true)
            @case13_current_user_post = create(:post, user_id: @client_user.id)
            @case13_follower_post = create_reply_to_prams_post(@follower, @case13_current_user_post)
          end

          travel_to Time.zone.local(2021, 8, 15) do
            @case18_19_follower_post1 = create(:post, user_id: @follower.id)
            @case18_19_follower_post2 = create_reply_to_prams_post(@follower, @case18_19_follower_post1)
            @case18_follower_post = create_reply_to_prams_post(@follower, @case18_19_follower_post2)
            @case18_current_user_post = create_reply_to_prams_post(@client_user, @case18_follower_post)
            @case19_current_user_post = create_reply_to_prams_post(@client_user, @case18_19_follower_post2)
            delete v1_post_path(@case18_follower_post.id), headers: @follower_headers
            delete v1_post_path(@case18_current_user_post.id), headers: @client_user_headers
          end

          travel_to Time.zone.local(2021, 8, 16) do
            @case20_current_user_post = create_reply_to_prams_post(@client_user, @case_20_21_follower_post2)
            @case21_current_user_post = create_reply_to_prams_post(@client_user, @case21_follower_post)
            delete v1_post_path(@case21_current_user_post.id), headers: @client_user_headers
          end

          travel_to Time.zone.local(2021, 8, 17) do
            @case22_23_follower_post = create(:post, user_id: @follower.id)
            @case22_current_user_post = create_reply_to_prams_post(@client_user, @case22_23_follower_post)
            @case22_follower_post1 = create_reply_to_prams_post(@follower, @case22_current_user_post)
            @case22_follower_post2 = create_reply_to_prams_post(@follower, @case22_follower_post1)
            @case23_current_user_post = create_reply_to_prams_post(@client_user, @case22_23_follower_post)
            delete v1_post_path(@case23_current_user_post.id), headers: @client_user_headers
          end

          travel_to Time.zone.local(2021, 8, 20) do
            @case5_current_user_post = create(:post, user_id: @client_user.id)
            @case6_follower_post = create(:post, user_id: @follower.id)
            @case7_current_user_post = create(:post, user_id: @client_user.id)
            @case8_follower_post = create(:post, user_id: @follower.id)
            @case5_current_user_post.update(is_locked: true)
            @case6_follower_post.update(is_locked: true)
          end

          travel_to Time.zone.local(2021, 8, 21, 5, 29, 59) do
            post v1_post_likes_path(@case5_current_user_post.id), headers: @client_user_headers
            post v1_post_likes_path(@case6_follower_post.id), headers: @client_user_headers
            post v1_post_likes_path(@case7_current_user_post.id), headers: @client_user_headers
            post v1_post_likes_path(@case8_follower_post.id), headers: @client_user_headers
          end

          travel_to Time.zone.local(2021, 8, 21, 5, 30, 0o0) do
            CurrentUserRefract.create(user_id: @client_user.id, performed_refract: false)
          end
        end

        it 'return 200 and sorted refract candidates' do
          travel_to Time.zone.local(2021, 8, 29) do
            client_user_headers = @client_user.create_new_auth_token
            get v1_post_refract_candidates_path, headers: client_user_headers
            expect(response).to have_http_status(200)
            expect(response.message).to include('OK')
            response_body = JSON.parse(response.body, symbolize_names: true)
            expect(response_body.length).to eq(5)
            expect(response_body[0][:like][:follower_post]).to have_id(@case8_follower_post.id)
            expect(response_body[0][:like][:follower_post].length).to eq(11)
            expect(response_body[1][:reply][:follower_post]).to have_id(@case22_follower_post2.id)
            expect(response_body[1][:reply][:follower_post].length).to eq(11)
            expect(response_body[2][:reply][:current_user_post]).to have_id(@case20_current_user_post.id)
            expect(response_body[2][:reply][:current_user_post].length).to eq(14)
            expect(response_body[3][:reply][:current_user_post]).to have_id(@case19_current_user_post.id)
            expect(response_body[3][:reply][:current_user_post].length).to eq(14)
            expect(response_body[4][:reply][:follower_post]).to have_id(@case13_follower_post.id)
            expect(response_body[4][:reply][:follower_post].length).to eq(11)
          end
        end
      end
    end
  end

  describe "GET /v1/refract_candidates/:id/threads
  - posts#thread_above_candidate - Get thread above candidate" do
    context "when client doesn't have token" do
      before do
        create(:icon)
      end

      let(:client_user)      { create(:user) }
      let(:client_user_post) { create(:post, user_id: client_user.id) }

      it "returns 401" do
        get v1_thread_above_candidate_path(client_user_post.id)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token and has performed CurrentUserRefract record" do
      before do
        create(:icon)
        CurrentUserRefract.create(user_id: client_user.id, performed_refract: true)
      end

      let(:client_user)         { create(:user) }
      let(:client_user_headers) { client_user.create_new_auth_token }
      let(:client_user_post)    { create(:post, user_id: client_user.id) }

      it 'returns 403' do
        expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 1
        expect(client_user.current_user_refracts.where(performed_refract: false).length).to eq 0

        get v1_thread_above_candidate_path(client_user_post.id), headers: client_user_headers
        expect(response).to have_http_status(403)
        expect(response.message).to include('Forbidden')
        expect(JSON.parse(response.body)['errors']['title']).to include('リフラクト機能を使用できません')
      end
    end

    context "when client has token and has not performed CurrentUserRefract record" do
      before do
        create(:icon)
        CurrentUserRefract.create(user_id: client_user.id, performed_refract: false)
      end

      let(:client_user)         { create(:user) }
      let(:client_user_headers) { client_user.create_new_auth_token }

      context "params post doesn't exist" do
        let(:non_existent_post_id) { get_non_existent_post_id }

        it 'returns 400' do
          get v1_thread_above_candidate_path(non_existent_post_id), headers: client_user_headers
          expect(response).to have_http_status(400)
          expect(response.message).to include('Bad Request')
          expect(JSON.parse(response.body)['errors']['title']).to include('パラメータのidが不正です')
        end
      end

      context "params post is deleted" do
        let(:deleted_post) { create(:post, user_id: client_user.id) }

        before do
          deleted_post.destroy
        end

        it 'returns 400' do
          get v1_thread_above_candidate_path(deleted_post.id), headers: client_user_headers
          expect(response).to have_http_status(400)
          expect(response.message).to include('Bad Request')
          expect(JSON.parse(response.body)['errors']['title']).to include('パラメータのidが不正です')
        end
      end

      context "params post replies to 5 posts
      3/5 posted by current user and 1 of them is deleted
      and 1/5 posted by follower
      and 1/5 posted by not follower" do
        let(:follower)     { create_follow_user(client_user) }
        let(:not_follower) { create_follow_user(follower) }

        let!(:deleted_client_user_post) { create(:post, user_id: client_user.id) }
        let!(:follower_post1)           { create_reply_to_prams_post(follower, deleted_client_user_post) }
        let!(:not_follower_post)        { create_reply_to_prams_post(not_follower, follower_post1) }
        let!(:follower_post2)           { create_reply_to_prams_post(follower, not_follower_post) }
        let!(:client_user_post)         { create_reply_to_prams_post(client_user, follower_post2) }

        # deleted_client_user_postに対するリプライを作成した後に投稿を削除すること。
        before do
          deleted_client_user_post.destroy
        end

        it 'returns 200 and thread sorted in asc order of created_at' do
          get v1_thread_above_candidate_path(client_user_post.id), headers: client_user_headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to                       eq(5)
          expect(response_body[0][:deleted]).to                 eq(nil)
          expect(response_body[1][:follower_post].length).to     eq(11)
          expect(response_body[1][:follower_post]).to            have_id(follower_post1.id)
          expect(response_body[2][:not_follower_post]).to        eq(nil)
          expect(response_body[3][:follower_post].length).to     eq(11)
          expect(response_body[3][:follower_post]).to            have_id(follower_post2.id)
          expect(response_body[4][:current_user_post].length).to eq(14)
          expect(response_body[4][:current_user_post]).to        have_id(client_user_post.id)
        end
      end
    end
  end

  describe "GET v1/posts/refracts/by_me
- posts#index_post_refracted_by_current_user - Get posts refracted by current user" do
    context "when client doesn't have token" do
      before do
        create(:icon)
      end

      it "returns 401" do
        get v1_post_refracted_by_current_user_path
        expect(response).to         have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user)         { create(:user) }
      let(:client_user_headers) { client_user.create_new_auth_token }
      let(:follower)            { create_follow_user(client_user) }
      let(:not_follower)        { create_follow_user(follower) }

      context "when client doesn't have performed CurrentUserRefract" do
        it 'returns 200' do
          expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 0

          get v1_post_refracted_by_current_user_path, headers: client_user_headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')
        end
      end

      context "when client have 1 performed CurrentUserRefract whose category is like
      and the refracted post is follower's" do
        let!(:follower_post) { create(:post, user_id: follower.id) }
        let!(:client_refract) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: follower_post.id,
            category: 'like'
          )
        end

        before do
          post v1_post_likes_path(follower_post.id), headers: client_user_headers
        end

        it 'returns 200 and formatted liked post' do
          expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 1

          get v1_post_refracted_by_current_user_path, headers: client_user_headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to                               eq(1)
          expect(response_body[0][:refracted_at]).to                    eq(I18n.l(client_refract.updated_at))
          expect(response_body[0][:posts][0][:follower_post].length).to eq(14)
          expect(response_body[0][:posts][0][:follower_post]).to        include(
            id: follower_post.id,
            user_id: follower_post.user_id,
            content: follower_post.content,
            image: follower_post.image.url,
            is_locked: follower_post.is_locked,
            icon_url: follower.image.url,
            username: follower.username,
            userid: follower.userid,
            replies: 0,
            is_reply: false,
            is_liked_by_current_user: true,
            created_at: I18n.l(follower_post.created_at),
          )
          expect(response_body[0][:posts][0][:follower_post]).to include(
            :deleted_at,
            :updated_at,
          )
        end
      end

      context "when client have 1 performed CurrentUserRefract whose category is like
      and the refracted post is not-follower's" do
        let!(:not_follower_post) { create(:post, user_id: follower.id) }
        let!(:client_refract) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: not_follower_post.id,
            category: 'like'
          )
        end

        before do
          post v1_post_likes_path(not_follower_post.id),     headers: client_user_headers
          delete v1_follower_path(follower_id: follower.id), headers: client_user_headers
        end

        it 'returns 200 and formatted liked post' do
          expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 1

          get v1_post_refracted_by_current_user_path, headers: client_user_headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to                            eq(1)
          expect(response_body[0][:refracted_at]).to                 eq(I18n.l(client_refract.updated_at))
          expect(response_body[0][:posts][0][:not_follower_post]).to eq(nil)
        end
      end

      context "when client have 1 performed CurrentUserRefract whose category is like
      and the refracted post is deleted" do
        let!(:follower_post) { create(:post, user_id: follower.id) }
        let!(:client_refract) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: follower_post.id,
            category: 'like'
          )
        end

        before do
          post v1_post_likes_path(follower_post.id), headers: client_user_headers
          follower_post.destroy
        end

        it 'returns 200 and formatted liked post' do
          expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 1

          get v1_post_refracted_by_current_user_path, headers: client_user_headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to                  eq(1)
          expect(response_body[0][:refracted_at]).to       eq(I18n.l(client_refract.updated_at))
          expect(response_body[0][:posts][0][:deleted]).to eq(nil)
        end
      end

      context "when client have 1 performed CurrentUserRefract whose category is reply
      and the thread includes posts posted by current user, follower and not-follower
      and the thread includes deleted post" do
        let!(:client_user_post)       { create(:post, user_id: client_user.id) }
        let!(:follower_reply)         { create_reply_to_prams_post(follower, client_user_post) }
        let!(:not_follower_reply)     { create_reply_to_prams_post(not_follower, follower_reply) }
        let!(:deleted_follower_reply) { create_reply_to_prams_post(follower, not_follower_reply) }

        let!(:client_refract) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: deleted_follower_reply.id,
            category: 'reply'
          )
        end

        before do
          deleted_follower_reply.destroy
        end

        it 'returns 200 and formatted replied post' do
          expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 1

          get v1_post_refracted_by_current_user_path, headers: client_user_headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(1)

          expect(response_body[0][:refracted_at]).to                        eq(I18n.l(client_refract.updated_at))
          expect(response_body[0][:posts].length).to                        eq(4)
          expect(response_body[0][:posts][0][:current_user_post].length).to eq(15)
          expect(response_body[0][:posts][0][:current_user_post]).to        include(
            id: client_user_post.id,
            user_id: client_user_post.user_id,
            content: client_user_post.content,
            image: client_user_post.image.url,
            is_locked: client_user_post.is_locked,
            created_at: I18n.l(client_user_post.created_at),
            is_reply: false,
            replies: 1,
            icon_url: client_user.image.url,
            username: client_user.username,
            userid: client_user.userid,
            is_liked_by_current_user: false,
            likes: 0
          )
          expect(response_body[0][:posts][0][:current_user_post]).to include(
            :deleted_at,
            :updated_at,
          )

          expect(response_body[0][:posts][1][:follower_post].length).to eq(14)
          expect(response_body[0][:posts][1][:follower_post]).to        include(
            id: follower_reply.id,
            user_id: follower_reply.user_id,
            content: follower_reply.content,
            image: follower_reply.image.url,
            is_locked: follower_reply.is_locked,
            created_at: I18n.l(follower_reply.created_at),
            is_reply: true,
            replies: 0,
            icon_url: follower.image.url,
            username: follower.username,
            userid: follower.userid,
            is_liked_by_current_user: false,
          )
          expect(response_body[0][:posts][1][:follower_post]).to include(
            :deleted_at,
            :updated_at,
          )

          expect(response_body[0][:posts][2]).to                     include(:not_follower_post)
          expect(response_body[0][:posts][2][:not_follower_post]).to eq(nil)

          expect(response_body[0][:posts][3]).to           include(:deleted)
          expect(response_body[0][:posts][3][:deleted]).to eq(nil)
        end
      end

      context "when client have 2 performed CurrentUserRefracts whose categories are like" do
        let!(:follower_post1) { create(:post, user_id: follower.id) }
        let!(:follower_post2) { create(:post, user_id: follower.id) }

        let!(:client_refract1) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: follower_post1.id,
            category: 'like'
          )
        end
        let!(:client_refract2) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: follower_post2.id,
            category: 'like'
          )
        end

        before do
          post v1_post_likes_path(follower_post1.id), headers: client_user_headers
          post v1_post_likes_path(follower_post2.id), headers: client_user_headers
        end

        it 'returns 200 and formatted liked post' do
          expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 2

          get v1_post_refracted_by_current_user_path, headers: client_user_headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(2)

          expect(response_body[0][:refracted_at]).to             eq(I18n.l(client_refract2.updated_at))
          expect(response_body[0][:posts][0][:follower_post]).to have_id(follower_post2.id)

          expect(response_body[1][:refracted_at]).to             eq(I18n.l(client_refract1.updated_at))
          expect(response_body[1][:posts][0][:follower_post]).to have_id(follower_post1.id)
        end
      end

      context "when client have 2 performed CurrentUserRefracts whose categories are reply" do
        let!(:client_user_post1) { create(:post, user_id: client_user.id) }
        let!(:follower_reply1)   { create_reply_to_prams_post(follower, client_user_post1) }
        let!(:client_user_post2) { create(:post, user_id: client_user.id) }
        let!(:follower_reply2)   { create_reply_to_prams_post(follower, client_user_post2) }

        let!(:client_refract1) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: follower_reply1.id,
            category: 'reply'
          )
        end
        let!(:client_refract2) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: follower_reply2.id,
            category: 'reply'
          )
        end

        it 'returns 200 and formatted replied posts' do
          expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 2

          get v1_post_refracted_by_current_user_path, headers: client_user_headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(2)

          expect(response_body[0][:refracted_at]).to                 eq(I18n.l(client_refract2.updated_at))
          expect(response_body[0][:posts][0][:current_user_post]).to have_id(client_user_post2.id)
          expect(response_body[0][:posts][1][:follower_post]).to     have_id(follower_reply2.id)

          expect(response_body[1][:refracted_at]).to                 eq(I18n.l(client_refract1.updated_at))
          expect(response_body[1][:posts][0][:current_user_post]).to have_id(client_user_post1.id)
          expect(response_body[1][:posts][1][:follower_post]).to     have_id(follower_reply1.id)
        end
      end

      context "when client have 3 performed CurrentUserRefracts whose categories are like and reply" do
        let!(:client_user_post1) { create(:post, user_id: client_user.id) }
        let!(:follower_reply1)   { create_reply_to_prams_post(follower, client_user_post1) }
        let!(:client_user_post2) { create(:post, user_id: client_user.id) }
        let!(:follower_reply2)   { create_reply_to_prams_post(follower, client_user_post2) }
        let!(:follower_post)     { create(:post, user_id: follower.id) }

        let!(:client_refract1) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: follower_reply1.id,
            category: 'reply'
          )
        end
        let!(:client_refract2) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: follower_post.id,
            category: 'like'
          )
        end
        let!(:client_refract3) do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: follower_reply2.id,
            category: 'reply'
          )
        end

        before do
          post v1_post_likes_path(follower_post.id), headers: client_user_headers
        end

        it 'returns 200 and formatted replied posts and liked post' do
          expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 3

          get v1_post_refracted_by_current_user_path, headers: client_user_headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body.length).to eq(3)

          expect(response_body[0][:refracted_at]).to                 eq(I18n.l(client_refract3.updated_at))
          expect(response_body[0][:posts][0][:current_user_post]).to have_id(client_user_post2.id)
          expect(response_body[0][:posts][1][:follower_post]).to     have_id(follower_reply2.id)

          expect(response_body[1][:refracted_at]).to             eq(I18n.l(client_refract2.updated_at))
          expect(response_body[1][:posts][0][:follower_post]).to have_id(follower_post.id)

          expect(response_body[2][:refracted_at]).to                 eq(I18n.l(client_refract1.updated_at))
          expect(response_body[2][:posts][0][:current_user_post]).to have_id(client_user_post1.id)
          expect(response_body[2][:posts][1][:follower_post]).to     have_id(follower_reply1.id)
        end
      end
    end
  end
end

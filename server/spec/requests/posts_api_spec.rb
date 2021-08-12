require 'rails_helper'

RSpec.describe "PostsApi", type: :request do
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
        FactoryBot.create_list(:icon, 5)
        sign_up('test')
        login('test')
        @headers = create_header_from_response(response)
      end

      it 'returns 200 and sets is_locked true when is_locked is true' do
        params = {
          content: 'Hello!',
          image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.png"), "image/png"),
          is_locked: true,
        }
        expect do
          post v1_posts_path, params: params, headers: @headers
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
          post v1_posts_path, params: params, headers: @headers
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
          post v1_posts_path, params: params, headers: @headers
        end.to change(Post.all, :count).by(1)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 400 when content has 141 characters" do
        params = {
          content: 'a' * 141,
        }
        post v1_posts_path, params: params, headers: @headers
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end

      it "returns 400 when content is blank" do
        params = {
          content: '',
        }
        post v1_posts_path, params: params, headers: @headers
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end

      it "returns 400 when content is nil" do
        params = {
          content: nil,
        }
        post v1_posts_path, params: params, headers: @headers
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end

      it "returns 200 when image's extension isn't jpg or png or gif or jpeg" do
        params = {
          content: 'Hello!',
          image: Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.svg"), "image/svg"),
          is_locked: true,
        }
        post v1_posts_path, params: params, headers: @headers
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end
    end
  end

  describe "DELETE /v1/posts - v1/posts#destroy - Delete login user's post" do
    before do
      @post_id, @request_headers = sign_up_and_create_a_new_post.values_at(:post_id, :request_headers)
    end

    context "when client doesn't have token" do
      it "returns 401" do
        delete destroy_v1_user_session_path params: @request_headers
        expect(response).to have_http_status(200)

        delete v1_post_path(@post_id)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      it "returns 200 and logically deletes post when try to delete login user's post" do
        expect do
          delete v1_post_path(@post_id), headers: @request_headers
        end.to change(Post.all, :count).by(-1)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
        expect(Post.with_deleted.where(id: @post_id).count).to eq 1
      end

      it "returns 400 when try to delete not login user's post" do
        another_user_post_id = sign_up_and_create_a_new_post[:post_id]
        expect(response).to have_http_status(200)

        login_user = User.find_by(uid: @request_headers[:uid])
        login(login_user.username)
        expect(response).to have_http_status(200)

        request_headers = create_header_from_response(response)
        expect do
          delete v1_post_path(another_user_post_id), headers: request_headers
        end.to change(Post.all, :count).by(0)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end
    end
  end

  describe "PUT /v1/posts/:id/change_lock - v1/posts#change_lock - Change is_locked of login user's post" do
    before do
      @post_id, @request_headers = sign_up_and_create_a_new_post.values_at(:post_id, :request_headers)
    end

    context "when client doesn't have token" do
      it "returns 401" do
        delete destroy_v1_user_session_path params: @request_headers
        expect(response).to have_http_status(200)

        put v1_post_changeLock_path(@post_id)
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      it "returns 200 and locks post when try to lock login user's unlocked post" do
        expect(Post.find(@post_id).is_locked).to eq(false)

        put v1_post_changeLock_path(@post_id), headers: @request_headers
        expect(Post.find(@post_id).is_locked).to eq(true)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 200 and unlocks post when try to unlock login user's locked post" do
        Post.find(@post_id).update(is_locked: true)
        expect(Post.find(@post_id).is_locked).to eq(true)

        put v1_post_changeLock_path(@post_id), headers: @request_headers
        expect(Post.find(@post_id).is_locked).to eq(false)
        expect(response).to have_http_status(200)
        expect(response.message).to include('OK')
      end

      it "returns 400 when try to lock not login user's unlocked post" do
        another_user_post_id = sign_up_and_create_a_new_post[:post_id]
        expect(response).to have_http_status(200)
        expect(Post.find(another_user_post_id).is_locked).to eq(false)

        put v1_post_changeLock_path(another_user_post_id), headers: @request_headers
        expect(Post.find(another_user_post_id).is_locked).to eq(false)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end

      it "returns 400 when try to unlock not login user's locked post" do
        another_user_post_id = sign_up_and_create_a_new_post[:post_id]
        expect(response).to have_http_status(200)

        Post.find(another_user_post_id).update(is_locked: true)
        expect(Post.find(another_user_post_id).is_locked).to eq(true)

        put v1_post_changeLock_path(another_user_post_id), headers: @request_headers
        expect(Post.find(another_user_post_id).is_locked).to eq(true)
        expect(response).to have_http_status(400)
        expect(response.message).to include('Bad Request')
      end
    end
  end
end

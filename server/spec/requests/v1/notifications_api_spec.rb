require 'rails_helper'

RSpec.describe "V1::Notifications", type: :request do
  describe "GET /v1/notifications - v1/notifications#index - Get notifications" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_notifications_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      context "when client has no notifications" do
        let(:client)  { create(:user) }
        let(:headers) { client.create_new_auth_token }

        it 'returns 200 and no notifications' do
          expect(Notification.where(notified_user_id: client.id)).not_to exist

          get v1_notifications_path, headers: headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:notifications].length).to eq(0)
        end
      end

      context "when client has 1 notification" do
        let(:client)         { create(:user) }
        let(:headers)        { client.create_new_auth_token }
        let(:liked_follower) { create_follower(client) }
        let(:liked_post)     { create(:post, user_id: client.id) }

        let!(:notification_like) do
          Notification.create(
            notify_user_id: liked_follower.id,
            notified_user_id: client.id,
            post_id: liked_post.id,
            action: 'like',
            is_checked: false
          )
        end

        it 'returns 200 and notification and change is_checked to true' do
          expect(Notification.where(notified_user_id: client.id).length).to eq(1)
          expect(Notification.where(notified_user_id: client.id, action: 'like', is_checked: false)).to exist

          get v1_notifications_path, headers: headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:notifications].length).to eq(1)
          expect(response_body[:notifications][0]).to include(
            action: 'like',
            notify_userid: nil,
            notify_username: nil,
            notify_user_icon_url: nil,
            is_checked: false,
            notified_at: format_to_rfc3339(notification_like.created_at),
            post_id: liked_post.id,
            content: liked_post.content,
          )

          expect(Notification.where(notified_user_id: client.id).length).to eq(1)
          expect(Notification.where(notified_user_id: client.id, action: 'like', is_checked: true)).to exist
        end
      end

      context "when client has 5 notifications" do
        let(:client)  { create(:user) }
        let(:headers) { client.create_new_auth_token }

        let(:liked_follower)               { create_follower(client) }
        let(:replied_follower)             { create_follower(client) }
        let(:requested_following_follower) { create_follower(client) }
        let(:accepted_following_follower)  { create_follower(client) }
        let(:refracted_follower)           { create_follower(client) }

        let(:liked_post)     { create(:post, user_id: client.id) }
        let(:replied_post)   { create(:post, user_id: client.id) }
        let(:refracted_post) { create(:post, user_id: client.id) }

        let!(:notification_like) do
          Notification.create(
            notify_user_id: liked_follower.id,
            notified_user_id: client.id,
            post_id: liked_post.id,
            action: 'like',
            is_checked: true
          )
        end
        let!(:notification_reply) do
          Notification.create(
            notify_user_id: replied_follower.id,
            notified_user_id: client.id,
            post_id: replied_post.id,
            action: 'reply',
            is_checked: true
          )
        end
        let!(:notification_request) do
          Notification.create(
            notify_user_id: requested_following_follower.id,
            notified_user_id: client.id,
            action: 'request',
            is_checked: false
          )
        end
        let!(:notification_accept) do
          Notification.create(
            notify_user_id: accepted_following_follower.id,
            notified_user_id: client.id,
            action: 'accept',
            is_checked: false
          )
        end
        let!(:notification_refract) do
          Notification.create(
            notify_user_id: refracted_follower.id,
            notified_user_id: client.id,
            post_id: refracted_post.id,
            action: 'refract',
            is_checked: false
          )
        end

        it 'returns 200 and notifications and change is_checked to true' do
          expect(Notification.where(notified_user_id: client.id).length).to eq(5)
          expect(Notification.where(notified_user_id: client.id, action: 'like', is_checked: true)).to exist
          expect(Notification.where(notified_user_id: client.id, action: 'reply', is_checked: true)).to exist
          expect(Notification.where(notified_user_id: client.id, action: 'request', is_checked: false)).to exist
          expect(Notification.where(notified_user_id: client.id, action: 'accept', is_checked: false)).to exist
          expect(Notification.where(notified_user_id: client.id, action: 'refract', is_checked: false)).to exist

          get v1_notifications_path, headers: headers
          expect(response).to have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:notifications].length).to eq(5)
          expect(response_body[:notifications][0]).to include(
            action: 'refract',
            notify_userid: refracted_follower.userid,
            notify_username: refracted_follower.username,
            notify_user_icon_url: refracted_follower.image.url,
            is_checked: false,
            notified_at: format_to_rfc3339(notification_refract.created_at),
            post_id: refracted_post.id,
            content: refracted_post.content,
          )
          expect(response_body[:notifications][1]).to include(
            action: 'accept',
            notify_userid: accepted_following_follower.userid,
            notify_username: accepted_following_follower.username,
            notify_user_icon_url: accepted_following_follower.image.url,
            is_checked: false,
            notified_at: format_to_rfc3339(notification_accept.created_at),
            post_id: nil,
            content: nil,
          )
          expect(response_body[:notifications][2]).to include(
            action: 'request',
            notify_userid: requested_following_follower.userid,
            notify_username: requested_following_follower.username,
            notify_user_icon_url: requested_following_follower.image.url,
            is_checked: false,
            notified_at: format_to_rfc3339(notification_request.created_at),
            post_id: nil,
            content: nil,
          )
          expect(response_body[:notifications][3]).to include(
            action: 'reply',
            notify_userid: nil,
            notify_username: nil,
            notify_user_icon_url: nil,
            is_checked: true,
            notified_at: format_to_rfc3339(notification_reply.created_at),
            post_id: replied_post.id,
            content: replied_post.content,
          )
          expect(response_body[:notifications][4]).to include(
            action: 'like',
            notify_userid: nil,
            notify_username: nil,
            notify_user_icon_url: nil,
            is_checked: true,
            notified_at: format_to_rfc3339(notification_like.created_at),
            post_id: liked_post.id,
            content: liked_post.content,
          )

          expect(Notification.where(notified_user_id: client.id).length).to eq(5)
          expect(Notification.where(notified_user_id: client.id, action: 'like', is_checked: true)).to exist
          expect(Notification.where(notified_user_id: client.id, action: 'reply', is_checked: true)).to exist
          expect(Notification.where(notified_user_id: client.id, action: 'request', is_checked: true)).to exist
          expect(Notification.where(notified_user_id: client.id, action: 'accept', is_checked: true)).to exist
          expect(Notification.where(notified_user_id: client.id, action: 'refract', is_checked: true)).to exist
        end
      end
    end
  end
end

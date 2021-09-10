require 'rails_helper'

RSpec.describe Notification, type: :model do
  context 'focus', :focus do
    before do
      create(:icon)
    end

    let(:notify_user)          { create(:user) }
    let(:notified_user)        { create(:user) }
    let(:notified_user_post)   { create(:post, user_id: notified_user.id) }
    let(:not_existent_userid)  { get_not_existent_userid }
    let(:not_existent_post_id) { get_non_existent_post_id }

    it 'is valid with normal system' do
      notification = Notification.new(
        notify_user_id: notify_user.id,
        notified_user_id: notified_user.id,
        action: 'like',
        post_id: notified_user_post.id
      )
      expect(notification).to be_valid
    end

    it 'is valid with normal system and action is reply' do
      notification = Notification.new(
        notify_user_id: notify_user.id,
        notified_user_id: notified_user.id,
        action: 'reply',
        post_id: notified_user_post.id
      )
      expect(notification).to be_valid
    end

    it 'is valid with normal system and action is request' do
      notification = Notification.new(
        notify_user_id: notify_user.id,
        notified_user_id: notified_user.id,
        action: 'request',
        post_id: notified_user_post.id
      )
      expect(notification).to be_valid
    end

    it 'is valid with normal system and action is accept' do
      notification = Notification.new(
        notify_user_id: notify_user.id,
        notified_user_id: notified_user.id,
        action: 'accept',
        post_id: notified_user_post.id
      )
      expect(notification).to be_valid
    end

    it 'is valid with normal system and action is refract' do
      notification = Notification.new(
        notify_user_id: notify_user.id,
        notified_user_id: notified_user.id,
        action: 'refract',
        post_id: notified_user_post.id
      )
      expect(notification).to be_valid
    end

    it 'is invalid with normal system and action is invalid' do
      notification = Notification.new(
        notify_user_id: notify_user.id,
        notified_user_id: notified_user.id,
        action: 'invalid',
        post_id: notified_user_post.id
      )
      expect(notification).to be_invalid
      expect(notification.errors[:action]).to include("is not included in the list")
    end

    it 'is invalid without notify_user_id' do
      notification = Notification.new(
        notified_user_id: notified_user.id,
        action: 'like',
        post_id: notified_user_post.id
      )
      expect(notification).to be_invalid
      expect(notification.errors[:notify_user_id]).to include("can't be blank")
    end

    it 'is invalid without notified_user_id' do
      notification = Notification.new(
        notify_user_id: notify_user.id,
        action: 'like',
        post_id: notified_user_post.id
      )
      expect(notification).to be_invalid
      expect(notification.errors[:notified_user_id]).to include("can't be blank")
    end

    it 'is invalid without action' do
      notification = Notification.new(
        notify_user_id: notify_user.id,
        notified_user_id: notified_user.id,
        post_id: notified_user_post.id
      )
      expect(notification).to be_invalid
      expect(notification.errors[:action]).to include("is not included in the list")
    end

    it "is invalid when notify_user_id isn't related to user" do
      notification = Notification.new(
        notify_user_id: not_existent_userid,
        notified_user_id: notified_user.id,
        action: 'like',
        post_id: notified_user_post.id
      )
      expect(notification).to be_invalid
    end

    it "is invalid when notified_user_id isn't related to user" do
      notification = Notification.new(
        notify_user_id: notify_user.id,
        notified_user_id: not_existent_userid,
        action: 'like',
        post_id: notified_user_post.id
      )
      expect(notification).to be_invalid
    end

    it "is invalid when post_id isn't related to post" do
      notification = Notification.new(
        notify_user_id: notify_user.id,
        notified_user_id: notified_user.id,
        action: 'like',
        post_id: not_existent_post_id
      )
      expect(notification).to be_invalid
    end
  end
end

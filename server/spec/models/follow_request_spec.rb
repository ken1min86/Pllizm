require 'rails_helper'

RSpec.describe FollowRequest, type: :model do
  it 'is valid with requested_by and request_to both of them relate to user' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    follow_request = FollowRequest.new(requested_by: user1.id, request_to: user2.id)
    expect(follow_request).to be_valid
  end

  it 'is invalid without requested_by' do
    user = FactoryBot.create(:user)
    follow_request = FollowRequest.new(request_to: user.id)
    expect(follow_request).to be_invalid
    expect(follow_request.errors[:requested_by]).to include("can't be blank")
  end

  it 'is invalid without request_to' do
    user = FactoryBot.create(:user)
    follow_request = FollowRequest.new(requested_by: user.id)
    expect(follow_request).to be_invalid
    expect(follow_request.errors[:request_to]).to include("can't be blank")
  end

  it "is invalid when requested_by doesn't relate to user" do
    user = FactoryBot.create(:user)
    non_existemt_user_id = get_non_existemt_user_id
    follow_request = FollowRequest.new(requested_by: non_existemt_user_id, request_to: user.id)
    expect(follow_request).to be_invalid
  end

  it "is invalid when request_to doesn't relate to user" do
    user = FactoryBot.create(:user)
    non_existemt_user_id = get_non_existemt_user_id
    follow_request = FollowRequest.new(requested_by: user.id, request_to: non_existemt_user_id)
    expect(follow_request).to be_invalid
  end

  def get_non_existemt_user_id
    non_existemt_userid = SecureRandom.alphanumeric(15)
    while User.find_by(userid: non_existemt_userid)
      non_existemt_userid = SecureRandom.alphanumeric(15)
    end
    non_existemt_userid
  end
end

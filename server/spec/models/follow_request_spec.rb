require 'rails_helper'

RSpec.describe FollowRequest, type: :model do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:non_existemt_user_id) { get_non_existemt_user_id() }

  it 'is valid with requested_by and request_to both of them relate to user' do
    follow_request = FollowRequest.new(requested_by: user1.id, request_to: user2.id)
    expect(follow_request).to be_valid
  end

  it 'is invalid without requested_by' do
    follow_request = FollowRequest.new(request_to: user1.id)
    expect(follow_request).to be_invalid
    expect(follow_request.errors[:requested_by]).to include("can't be blank")
  end

  it 'is invalid without request_to' do
    follow_request = FollowRequest.new(requested_by: user1.id)
    expect(follow_request).to be_invalid
    expect(follow_request.errors[:request_to]).to include("can't be blank")
  end

  it "is invalid when requested_by doesn't relate to user" do
    follow_request = FollowRequest.new(requested_by: non_existemt_user_id, request_to: user1.id)
    expect(follow_request).to be_invalid
  end

  it "is invalid when request_to doesn't relate to user" do
    follow_request = FollowRequest.new(requested_by: user1.id, request_to: non_existemt_user_id)
    expect(follow_request).to be_invalid
  end

  it 'returns 200 and deletes follow request when user relates to requested_by is deleted' do
    user1.follow_requests.create(request_to: user2.id)
    expect(FollowRequest.where(requested_by: user1.id, request_to: user2.id)).to exist

    user1.destroy
    expect(FollowRequest.where(requested_by: user1.id, request_to: user2.id)).not_to exist
  end

  it 'returns 200 and deletes follow request when user relates to request_to is deleted' do
    user2.follow_requests.create(request_to: user1.id)
    expect(FollowRequest.where(requested_by: user2.id, request_to: user1.id)).to exist

    user2.destroy
    expect(FollowRequest.where(requested_by: user2.id, request_to: user1.id)).not_to exist
  end
end

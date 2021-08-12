require 'rails_helper'

RSpec.describe Follower, type: :model do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:non_existemt_user_id) { get_non_existemt_user_id }

  it 'is valid with followed_by and follow_to both of them relate to user' do
    follower = Follower.new(followed_by: user1.id, follow_to: user2.id)
    expect(follower).to be_valid
  end

  it 'is invalid without followed_by' do
    follower = Follower.new(follow_to: user1.id)
    expect(follower).to be_invalid
    expect(follower.errors[:followed_by]).to include("can't be blank")
  end

  it 'is invalid without follow_to' do
    follower = Follower.new(followed_by: user1.id)
    expect(follower).to be_invalid
    expect(follower.errors[:follow_to]).to include("can't be blank")
  end

  it "is invalid when followed_by doesn't relate to user" do
    follower = Follower.new(followed_by: non_existemt_user_id, follow_to: user1.id)
    expect(follower).to be_invalid
  end

  it "is invalid when user doesn't relate to user" do
    follower = Follower.new(followed_by: user1.id, follow_to: non_existemt_user_id)
    expect(follower).to be_invalid
  end

  it 'returns 200 and deletes follower when user relates to followed_by is deleted' do
    user1.follow_relationships.create(follow_to: user2.id)
    expect(Follower.where(followed_by: user1.id, follow_to: user2.id)).to exist

    user1.destroy
    expect(Follower.where(followed_by: user1.id, follow_to: user2.id)).not_to exist
  end

  it 'returns 200 and deletes follower when user relates to follow_to is deleted' do
    user2.follow_relationships.create(follow_to: user1.id)
    expect(Follower.where(followed_by: user2.id, follow_to: user1.id)).to exist

    user2.destroy
    expect(Follower.where(followed_by: user2.id, follow_to: user1.id)).not_to exist
  end
end

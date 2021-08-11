require 'rails_helper'

RSpec.describe Follower, type: :model do
  it 'is valid with followed_by and follow_to both of them relate to user' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    follower = Follower.new(followed_by: user1.id, follow_to: user2.id)
    expect(follower).to be_valid
  end

  it 'is invalid without followed_by' do
    user = FactoryBot.create(:user)
    follower = Follower.new(follow_to: user.id)
    expect(follower).to be_invalid
    expect(follower.errors[:followed_by]).to include("can't be blank")
  end

  it 'is invalid without follow_to' do
    user = FactoryBot.create(:user)
    follower = Follower.new(followed_by: user.id)
    expect(follower).to be_invalid
    expect(follower.errors[:follow_to]).to include("can't be blank")
  end

  it "is invalid when followed_by doesn't relate to user" do
    user = FactoryBot.create(:user)
    non_existemt_user_id = get_non_existemt_user_id
    follower = Follower.new(followed_by: non_existemt_user_id, follow_to: user.id)
    expect(follower).to be_invalid
  end

  it "is invalid when user doesn't relate to user" do
    user = FactoryBot.create(:user)
    non_existemt_user_id = get_non_existemt_user_id
    follower = Follower.new(followed_by: user.id, follow_to: non_existemt_user_id)
    expect(follower).to be_invalid
  end

  def get_non_existemt_user_id
    non_existemt_userid = SecureRandom.alphanumeric(15)
    while User.find_by(userid: non_existemt_userid)
      non_existemt_userid = SecureRandom.alphanumeric(15)
    end
    non_existemt_userid
  end
end

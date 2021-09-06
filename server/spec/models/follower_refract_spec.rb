require 'rails_helper'

RSpec.describe FollowerRefract, type: :model do
  before do
    create(:icon)
  end

  let(:user)                 { create(:user) }
  let(:follower)             { create_follow_user(user) }
  let(:non_existent_user_id) { get_non_existent_user_id }
  let!(:user_post)           { create(:post, user_id: user.id) }
  let(:non_existent_post_id) { get_non_existent_post_id }

  it 'is valid when nomal system and category is like' do
    follower_refract = user.follower_refracts.new(
      follower_id: follower.id,
      post_id: user_post.id,
      category: 'like'
    )
    expect(follower_refract).to be_valid
  end

  it 'is valid when nomal system and category is reply' do
    follower_refract = FollowerRefract.new(
      user_id: user.id,
      follower_id: follower.id,
      post_id: user_post.id,
      category: 'reply'
    )
    expect(follower_refract).to be_valid
  end

  it 'is invalid without user_id' do
    follower_refract = FollowerRefract.new(
      follower_id: follower.id,
      post_id: user_post.id,
      category: 'like'
    )
    expect(follower_refract).to be_invalid
    expect(follower_refract.errors[:user_id]).to include("can't be blank")
  end

  it 'is invalid without follower_id' do
    follower_refract = FollowerRefract.new(
      user_id: user.id,
      post_id: user_post.id,
      category: 'like'
    )
    expect(follower_refract).to be_invalid
    expect(follower_refract.errors[:follower_id]).to include("can't be blank")
  end

  it "is invalid without post_id" do
    follower_refract = FollowerRefract.new(
      user_id: user.id,
      follower_id: follower.id,
      category: 'like'
    )
    expect(follower_refract).to be_invalid
    expect(follower_refract.errors[:post_id]).to include("can't be blank")
  end

  it "is invalid when user_id doesn't relate to user" do
    follower_refract = FollowerRefract.new(
      user_id: non_existent_user_id,
      follower_id: follower.id,
      post_id: user_post.id,
      category: 'like'
    )
    expect(follower_refract).to be_invalid
  end

  it "is invalid when follower_id doesn't relate to user" do
    follower_refract = FollowerRefract.new(
      user_id: user.id,
      follower_id: non_existent_user_id,
      post_id: user_post.id,
      category: 'like'
    )
    expect(follower_refract).to be_invalid
  end

  it "is invalid when post_id doesn't relate to post" do
    follower_refract = FollowerRefract.new(
      user_id: user.id,
      follower_id: follower.id,
      post_id: non_existent_post_id,
      category: 'like'
    )
    expect(follower_refract).to be_invalid
  end

  it "is invalid when category isn't reply or like" do
    follower_refract = FollowerRefract.new(
      user_id: user.id,
      follower_id: follower.id,
      post_id: user_post.id,
      category: 'good'
    )
    expect(follower_refract).to be_invalid
    expect(follower_refract.errors[:category]).to include("is not included in the list")
  end
end

require 'rails_helper'

RSpec.describe Like, type: :model do
  before do
    FactoryBot.create(:icon)
  end

  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post, user_id: user.id) }
  let(:non_existent_userid)  { get_non_existent_user_id }
  let(:non_existent_post_id) { get_non_existent_post_id }

  it 'is valid with related user_id and post_id' do
    like = Like.new(user_id: user.id, post_id: post.id)
    expect(like).to be_valid
  end

  it 'is invalid with not related user_id' do
    like = Like.new(user_id: non_existent_userid, post_id: post.id)
    expect(like).to be_invalid
  end

  it 'is invalid with not related post_id' do
    like = Like.new(user_id: user.id, post_id: non_existent_post_id)
    expect(like).to be_invalid
  end

  it 'is invalid with not unique user_id and post_id' do
    Like.create(user_id: user.id, post_id: post.id)
    like = Like.new(user_id: user.id, post_id: post.id)
    like.valid?
    expect(like.errors[:post_id]).to include('has already been taken')
  end

  it 'is invalid without user_id' do
    like = Like.new(post_id: post.id)
    like.valid?
    expect(like.errors[:user_id]).to include("can't be blank")
  end

  it 'is invalid without post_id' do
    like = Like.new(user_id: user.id)
    like.valid?
    expect(like.errors[:post_id]).to include("can't be blank")
  end
end

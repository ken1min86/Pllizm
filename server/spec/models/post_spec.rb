require 'rails_helper'

RSpec.describe Post, type: :model do
  before :all do
    10.times do
      FactoryBot.create(:icon)
    end
  end

  let!(:user) { FactoryBot.create(:user) }

  it "is valid when user_id relates to user.id and icon_id relates to icon.id" do
    post = FactoryBot.create(:post, user_id: user.id)
    expect(post).to be_valid
    expect(post.id.length).to eq(20)
    expect(post.is_locked).to eq(false)
    expect(Icon.all.any?{|icon| post.icon_id == icon.id}).to be_truthy
  end

  it "is valid when image's extension is jpg" do
    post = FactoryBot.build(:post, user_id: user.id, image: 'food.jpg')
    expect(post).to be_valid
  end

  it "is valid when image's extension is png" do
    post = FactoryBot.build(:post, user_id: user.id, image: 'food.png')
    expect(post).to be_valid
  end

  it "is valid when image's extension is gif" do
    post = FactoryBot.build(:post, user_id: user.id, image: 'food.gif')
    expect(post).to be_valid
  end

  it "is invalid when image's extension isn't jpg or png or gif" do
    post = FactoryBot.build(:post, user_id: user.id, image: 'food.svg')
    expect(post).to be_invalid
  end

  it 'is valid when content has 140 characters' do
    post = FactoryBot.build(:post, user_id: user.id, content: 'a' * 140)
    expect(post).to be_valid
  end

  it 'is invalid when content has 141 characters' do
    post = FactoryBot.build(:post, user_id: user.id, content: 'a' * 141)
    expect(post).to be_invalid
  end

  it 'is invalid when content is blank' do
    post = FactoryBot.build(:post, user_id: user.id, content: '')
    expect(post).to be_invalid
  end

  it 'is invalid when content is nil' do
    post = FactoryBot.build(:post, user_id: user.id, content: nil)
    expect(post).to be_invalid
  end

  it 'is invalid without user_id' do
    post = FactoryBot.build(:post, user_id: nil)
    expect(post).to be_invalid
  end

  it "is invalid when user_id doesn't relate to user.id" do
    post = FactoryBot.build(:post, user_id: User.last.id + 1)
    expect(post).to be_invalid
  end

  it 'is logically deleted when deleting' do
    post = FactoryBot.create(:post, user_id: user.id)
    expect do
      post.destroy
    end. to change(Post.all, :count).by(-1)
    expect(Post.only_deleted.find(post.id)).to be_truthy
  end

  it "is logically deleted when related user was logically deleted" do
    post = FactoryBot.create(:post, user_id: user.id)
    expect do
      user.destroy
    end. to change(Post.all, :count).by(-1)
    expect(Post.only_deleted.find(post.id)).to be_truthy
  end
end

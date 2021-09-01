require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    create_list(:icon, 10)
  end

  let!(:user) { create(:user) }

  it "is valid when user_id relates to user.id and icon_id relates to icon.id" do
    post = create(:post, user_id: user.id)
    expect(TreePath.where(ancestor: post.id, descendant: post.id, depth: 0)).to exist
    expect(post).to be_valid
    expect(post.id.length).to eq(20)
    expect(post.is_locked).to eq(false)
    expect(Icon.all.any? { |icon| post.icon_id == icon.id }).to be_truthy
  end

  it "is valid when image's extension is jpg" do
    image_path = Rails.root.join("db/icons/Account-icon1.jpg")
    post = build(:post, user_id: user.id, image: Rack::Test::UploadedFile.new(image_path, "image/jpg"))
    expect(post).to be_valid
  end

  it "is valid when image's extension is png" do
    image_path = Rails.root.join("spec/factories/test_icons/Account-icon1.png")
    post = build(:post, user_id: user.id, image: Rack::Test::UploadedFile.new(image_path, "image/png"))
    expect(post).to be_valid
  end

  it "is valid when image's extension is gif" do
    image_path = Rails.root.join("db/icons/Account-icon1.gif")
    post = build(:post, user_id: user.id, image: Rack::Test::UploadedFile.new(image_path, "image/gif"))
    expect(post).to be_valid
  end

  it "is valid when image's extension is jpeg" do
    image_path = Rails.root.join("db/icons/Account-icon1.jpeg")
    post = build(:post, user_id: user.id, image: Rack::Test::UploadedFile.new(image_path, "image/jpeg"))
    expect(post).to be_valid
  end

  it "is invalid when image's extension isn't jpg or png or gif or jpeg" do
    image_path = Rails.root.join("db/icons/Account-icon1.svg")
    post = build(:post, user_id: user.id, image: Rack::Test::UploadedFile.new(image_path, "image/svg"))
    expect(post).to be_invalid
  end

  it 'is valid when content has 140 characters' do
    post = build(:post, user_id: user.id, content: 'a' * 140)
    expect(post).to be_valid
  end

  it 'is invalid when content has 141 characters' do
    post = build(:post, user_id: user.id, content: 'a' * 141)
    expect(post).to be_invalid
  end

  it 'is invalid when content is blank' do
    post = build(:post, user_id: user.id, content: '')
    expect(post).to be_invalid
  end

  it 'is invalid when content is nil' do
    post = build(:post, user_id: user.id, content: nil)
    expect(post).to be_invalid
  end

  it 'is invalid without user_id' do
    post = build(:post, user_id: nil)
    expect(post).to be_invalid
  end

  it "is invalid when user_id doesn't relate to user.id" do
    post = build(:post, user_id: User.last.id + 1)
    expect(post).to be_invalid
  end

  it 'is logically deleted when deleting' do
    post = create(:post, user_id: user.id)
    expect do
      post.destroy
    end. to change(Post.all, :count).by(-1)
    expect(Post.only_deleted.find(post.id)).to be_truthy
  end

  it "is logically deleted when related user was logically deleted" do
    post = create(:post, user_id: user.id)
    expect do
      user.destroy
    end. to change(Post.all, :count).by(-1)
    expect(Post.only_deleted.find(post.id)).to be_truthy
  end
end

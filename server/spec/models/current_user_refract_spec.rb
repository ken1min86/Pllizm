require 'rails_helper'

RSpec.describe CurrentUserRefract, type: :model do
  before do
    FactoryBot.create(:icon)
  end

  let(:user)                 { FactoryBot.create(:user) }
  let(:non_existent_user_id) { get_non_existent_user_id }
  let!(:user_post)           { FactoryBot.create(:post, user_id: user.id) }
  let(:non_existent_post_id) { get_non_existent_post_id }

  it 'is valid when nomal system and category is like' do
    current_user_refract = CurrentUserRefract.create(
      user_id: user.id,
      performed_refract: false,
      post_id: user_post.id,
      category: 'like'
    )
    expect(current_user_refract).to be_valid
  end

  it 'is valid when nomal system and category is reply' do
    current_user_refract = CurrentUserRefract.new(
      user_id: user.id,
      performed_refract: true,
      post_id: user_post.id,
      category: 'reply'
    )
    expect(current_user_refract).to be_valid
  end

  it 'is invalid without user_id' do
    current_user_refract = CurrentUserRefract.new(
      performed_refract: true,
      post_id: user_post.id,
      category: 'reply'
    )
    expect(current_user_refract).to be_invalid
    expect(current_user_refract.errors[:user_id]).to include("can't be blank")
  end

  it "is invalid whe user_id doesn't relate to user" do
    current_user_refract = CurrentUserRefract.new(
      user_id: non_existent_user_id,
      performed_refract: true,
      post_id: user_post.id,
      category: 'reply'
    )
    expect(current_user_refract).to be_invalid
  end

  it "is invalid whe post_id doesn't relate to post" do
    current_user_refract = CurrentUserRefract.new(
      user_id: user.id,
      performed_refract: true,
      post_id: non_existent_post_id,
      category: 'reply'
    )
    expect(current_user_refract).to be_invalid
  end

  it "is invalid whe performed_refract isn't reply or like" do
    current_user_refract = CurrentUserRefract.new(
      user_id: user.id,
      performed_refract: 1,
      post_id: user_post.id,
      category: 'good'
    )
    expect(current_user_refract).to be_invalid
  end
end

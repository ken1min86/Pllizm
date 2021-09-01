require 'rails_helper'

RSpec.describe CurrentUserRefract, type: :model do
  before do
    create(:icon)
  end

  let(:user)                 { create(:user) }
  let(:non_existent_user_id) { get_non_existent_user_id }
  let!(:user_post)           { create(:post, user_id: user.id) }
  let(:non_existent_post_id) { get_non_existent_post_id }

  it 'is valid when nomal system and category is like' do
    current_user_refract = user.current_user_refracts.new(
      performed_refract: false,
      post_id: user_post.id,
      category: 'like'
    )
    expect(current_user_refract).to be_valid
  end

  it 'is valid when nomal system and category is reply' do
    current_user_refract = user_post.current_user_refracts.new(
      user_id: user.id,
      performed_refract: true,
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

  it "is invalid without performed_refract" do
    current_user_refract = CurrentUserRefract.new(
      user_id: user.id,
      post_id: user_post.id,
      category: 'reply'
    )
    expect(current_user_refract).to be_invalid
    expect(current_user_refract.errors[:performed_refract]).to include("is not included in the list")
  end

  it "is invalid when user_id doesn't relate to user" do
    current_user_refract = CurrentUserRefract.new(
      user_id: non_existent_user_id,
      performed_refract: true,
      post_id: user_post.id,
      category: 'reply'
    )
    expect(current_user_refract).to be_invalid
  end

  it "is invalid when post_id doesn't relate to post" do
    current_user_refract = CurrentUserRefract.new(
      user_id: user.id,
      performed_refract: true,
      post_id: non_existent_post_id,
      category: 'reply'
    )
    expect(current_user_refract).to be_invalid
  end

  it "is invalid when category isn't reply or like" do
    current_user_refract = CurrentUserRefract.new(
      user_id: user.id,
      performed_refract: false,
      post_id: user_post.id,
      category: 'good'
    )
    expect(current_user_refract).to be_invalid
    expect(current_user_refract.errors[:category]).to include("is not included in the list")
  end
end

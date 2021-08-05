require 'rails_helper'

RSpec.describe User, type: :model do
  # 前提：現時点でproviderは未設定で登録する(DBではデフォルトのemailが設定される)ものとする, またdeviseの設定によりuidにはemailの値が設定される
  # 理由：OAuthが未実装であり、現状必ずメアドで登録されるため、providerはemailで固定とする
  context 'when there are no users before test' do
    it 'is valid with email and password with 8 or more digits and 128 or less digits' do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
      expect(user.provider).to eq 'email'
    end

    it 'is invalid without email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).to be_invalid
    end

    it 'is invalid without password' do
      user = FactoryBot.build(:user, password: nil)
      expect(user).to be_invalid
    end

    it 'is invalid when password has 7 digits' do
      user = FactoryBot.build(:user, password: 'a' * 7)
      expect(user).to be_invalid
    end

    it 'is valid when password has 8 digits' do
      user = FactoryBot.build(:user, password: 'a' * 8)
      expect(user).to be_valid
    end

    it 'is valid when password has 128 digits' do
      user = FactoryBot.build(:user, password: 'a' * 128)
      expect(user).to be_valid
    end

    it 'is invalid when password has 129 digits' do
      user = FactoryBot.build(:user, password: 'a' * 129)
      expect(user).to be_invalid
    end

    it 'is valid whose username has 50 characters' do
      user = FactoryBot.build(:user, username: 'a' * 50)
      expect(user).to be_valid
    end

    it 'is invalid whose username has 51 characters' do
      user = FactoryBot.build(:user, username: 'a' * 51)
      expect(user).to be_invalid
    end

    it 'is invalid whose bio has 160 character' do
      user = FactoryBot.build(:user, bio: 'a' * 160)
      expect(user).to be_valid
    end

    it 'is valid whose bio has 161 character' do
      user = FactoryBot.build(:user, bio: 'a' * 161)
      expect(user).to be_invalid
    end

    it 'is valid when userid has 15 character' do
      user = FactoryBot.build(:user, userid: 'a' * 15)
      expect(user).to be_valid
    end

    it 'is invalid when userid has 16 character' do
      user = FactoryBot.build(:user, userid: 'a' * 16)
      expect(user).to be_invalid
    end
  end

  # 現状providerはemailのみなので、providerがemailのときのテストだけ実施している
  context 'when there is a user(called USER1) before test' do
    let!(:user1) { FactoryBot.create(:user) }

    it "is valid when provider equals to USER1 and email doesn't equal to USER1" do
      user2 = FactoryBot.build(:user)
      expect(user2).to be_valid
    end

    it "is invalid when provider and email equal to USER1" do
      user2 = FactoryBot.build(:user, email: user1.email)
      expect(user2).to be_invalid
    end

    it "is valid when userid doesn't equal to USER1" do
      user2 = FactoryBot.build(:user)
      expect(user2).to be_valid
    end

    it "is invalid when userid equals to USER1" do
      user2 = FactoryBot.build(:user, userid: user1.userid)
      expect(user2).to be_invalid
    end
  end
end

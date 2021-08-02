require 'rails_helper'

RSpec.describe User, type: :model do
  # 前提：現時点でproviderは未設定で登録する(DBではデフォルトのemailが設定される)ものとする, またdeviseの設定によりuidにはemailの値が設定される
  # 理由：OAuthが未実装であり、現状必ずメアドで登録されるため、providerはemailで固定とする
  context 'when there are no users before test' do
    it 'is valid with email, name and password' do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
    end

    it 'is invalid without email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).to be_invalid
    end

    it 'is invalid without name' do
      user = FactoryBot.build(:user, name: nil)
      expect(user).to be_invalid
    end

    it 'is invalid without password' do
      user = FactoryBot.build(:user, password: nil)
      expect(user).to be_invalid
    end
  end

  # providerが未設定(デフォルトで"email"が設定される)場合の、文字数制限のバリデーション
  context 'when there is only one user whose provider is blank and user has email, name, uid and password' do
    it 'is valid whose name has 50 characters' do
      user = FactoryBot.build(:user, name: 'NakagawakeNakagawakeNakagawakeNakagawakeNakagawake')
      expect(user).to be_valid
    end

    it 'is invalid whose name has 51 characters' do
      user = FactoryBot.build(:user, name: 'NakagawakeNakagawakeNakagawakeNakagawakeNakagawakeN')
      expect(user).to be_invalid
    end
  end

  # providerの値に関わらない、文字数制限のバリデーション
  context 'when there is one user with email, name, uid and password' do
    it 'is invalid whose bio has 160 character' do
      user = FactoryBot.build(:user, bio: 'こんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんは')
      expect(user).to be_valid
    end

    it 'is valid whose bio has 161 character' do
      user = FactoryBot.build(:user, bio: 'こんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこんにちはこんばんはこ')
      expect(user).to be_invalid
    end
  end

  context 'when all user have email, name and password and there is a user(called USER1) before test' do
    let!(:user1) { FactoryBot.create(:user) }

    it "is valid provider equals to USER1 and email doesn't equal to USER1" do
      user2 = FactoryBot.build(:user)
      expect(user2).to be_valid
    end

    it "is invalid provider and email equal to USER1" do
      user2 = FactoryBot.build(:user, email: user1.email)
      expect(user2).to be_invalid
    end
  end
end

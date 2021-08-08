require 'rails_helper'

RSpec.describe "PostsApi", type: :request do
  describe "POST /v1/posts - v1/posts#create - Create new post" do
    context "when client hasn't login" do
      it "returns 401" do
        post v1_posts_path, params: {
          "content": 'Hello!',
        }
        expect(response.message).to include('Unauthorized')
        expect(response).to have_http_status(401)
      end
    end

    context "when client has logined" do
      # before :all do
      #   10.times do
      #     FactoryBot.create(:icon)
      #   end
      # end

      before do
        sign_up('test')
        # post v1_user_session_path, params: {
        #   email: 'test@gmail.com',
        #   password: 'password123',
        # }
      end

      it 'returns 200 and sets is_locked true when is_locked is true' do
        # post v1_posts_path, params: {
        #   "content": 'Hello!',
        #   "image":
        # }
        # 前提：
        # ログインユーザ
        # contentがblank or nilでない
        # imageの拡張子が正常
        # locked_true

        # 200
        # status success
        # message
        # icon_idがランダムに設定されていること
        # lockedがtrueなこと
        # user_idがログインユーザidなこと
        # contentが保存
        # imageが保存
      end

      it 'returns 200 and sets is_locked false when is_locked is nil'
      it "returns 200 when content has 140 characters"
      it "returns 422 when content has 141 characters"
      it "returns 422 when content is blank"
      it "returns 422 when content is nil"
      it "returns 200 when image's extension is jpg"
      it "returns 200 when image's extension is png"
      it "returns 200 when image's extension is gif"
      it "returns 200 when image's extension isn't jpg or png or gif"
    end
  end
end

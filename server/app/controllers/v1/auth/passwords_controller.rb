module V1
  module Auth
    class PasswordsController < DeviseTokenAuth::PasswordsController
      before_action :prohibit_chages_to_guest_user, only: %i(create edit update)

      private

      def prohibit_chages_to_guest_user
        render_json_forbitten_with_custom_errors("変更できません。", "ゲストユーザーのパスワードは変更できません。") if current_v1_user.userid == "test"
      end
    end
  end
end

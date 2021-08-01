module V1
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      private

      def sign_up_params
        params.permit(:name, :email, :uid, :password, :password_confirmation)
      end

      def account_update_params
        params.permit(:name, :email, :uid)
      end
    end
  end
end

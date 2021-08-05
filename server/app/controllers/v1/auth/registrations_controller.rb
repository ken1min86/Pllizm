module V1
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :confirm_password_confirmation_existence, only: :create
      before_action :confirm_email_existence, only: :create
      after_action  :set_userid_and_username, only: :create

      private

      def confirm_password_confirmation_existence
        unless params[:password_confirmation]
          render status: 422, json: { status: 422, message: "Unprocessable Entity" }
        end
      end

      def confirm_email_existence
        unless params[:email]
          render status: 422, json: { status: 422, message: "Unprocessable Entity" }
        end
      end

      def set_userid_and_username
        username = current_v1_user.email.split("@")[0]
        current_v1_user.update(username: username)
      end

      def sign_up_params
        params.permit(:email, :password, :password_confirmation)
      end

      def account_update_params
        params.permit(:email, :username, :uid, :bio, :image)
      end
    end
  end
end

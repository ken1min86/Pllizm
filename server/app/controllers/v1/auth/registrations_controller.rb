require 'securerandom'

module V1
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :confirm_password_confirmation_existence, only: :create
      before_action :confirm_email_existence, only: :create
      after_action  :set_userid_and_username, only: :create
      before_action :check_userid_is_at_least_4_digits, only: :update

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
        random_userid = get_unique_userid()
        username = current_v1_user.email.split("@")[0]
        current_v1_user.update(userid: random_userid, username: username)
      end

      def check_userid_is_at_least_4_digits
        if params[:userid]&.length < 4
          render status: 422, json: { status: 422, message: "Unprocessable Entity" }
        end
      end

      def get_unique_userid
        random_userid = SecureRandom.alphanumeric(15)
        while User.find_by(userid: random_userid) do
          random_userid = SecureRandom.alphanumeric(15)
        end
        return random_userid
      end

      def sign_up_params
        params.permit(:email, :password, :password_confirmation)
      end

      def account_update_params
        params.permit(:email, :username, :userid, :bio, :image)
      end
    end
  end
end

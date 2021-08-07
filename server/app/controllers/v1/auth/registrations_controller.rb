require 'securerandom'

module V1
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :check_password_confirmation_existence, only: :create
      before_action :check_email_existence, only: :create
      before_action :add_userid_to_params, only: :create
      before_action :add_username_to_params, only: :create
      before_action :check_userid_is_at_least_4_characters, only: :update
      before_action :check_image_has_correct_extension, only: :update

      private

      def check_password_confirmation_existence
        unless params[:password_confirmation]
          render status: 422, json: { status: 422, message: "Unprocessable Entity" }
        end
      end

      def check_email_existence
        unless params[:email]
          render status: 422, json: { status: 422, message: "Unprocessable Entity" }
        end
      end

      def add_userid_to_params
        params[:userid] = get_unique_userid
      end

      def add_username_to_params
        if params[:email]&.split("@")[0]
          params[:username] = params[:email].split("@")[0]
        end
      end

      def get_unique_userid
        random_userid = SecureRandom.alphanumeric(15)
        while User.find_by(userid: random_userid)
          random_userid = SecureRandom.alphanumeric(15)
        end
        random_userid
      end

      def check_userid_is_at_least_4_characters
        if params[:userid]&.length && params[:userid]&.length < 4
          render status: 422, json: { status: 422, message: "Unprocessable Entity" }
        end
      end

      def check_image_has_correct_extension
        valid_extensions = ['.gif', ".png", ".jpg"]
        if params[:image]&.length && !valid_extensions.any? { |valid_extension| params[:image].include? valid_extension }
          render status: 422, json: { status: 422, message: "Unprocessable Entity" }
        end
      end

      def sign_up_params
        params.permit(:email, :password, :password_confirmation, :userid, :username)
      end

      def account_update_params
        params.permit(:email, :userid, :username, :userid, :bio, :image)
      end
    end
  end
end

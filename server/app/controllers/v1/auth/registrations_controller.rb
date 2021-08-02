module V1
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :create_username_from_email, only: :create
      before_action :confirm_password_existence, only: :create

      private

      def create_username_from_email
        if params[:email]
          name = params[:email].split("@")[0]
          params[:name] = name
        end
      end

      def confirm_password_existence
        unless params[:password_confirmation]
          render status: 422, json: { status: 422, message: "Unprocessable Entity" }
        end
      end

      def sign_up_params
        params.permit(:email, :name, :password, :password_confirmation)
      end

      def account_update_params
        params.permit(:email, :name, :uid, :bio, :image)
      end
    end
  end
end

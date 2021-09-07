module V1
  class CurrentUserRefractsController < ApplicationController
    before_action :authenticate_v1_user!

    def show_statuses
      exist_not_performed_refract = CurrentUserRefract.exists?(
        user_id: current_v1_user.id,
        performed_refract: false
      )
      performed_refract = !exist_not_performed_refract
      render json: { performed_refract: performed_refract }, status: :ok
    end
  end
end

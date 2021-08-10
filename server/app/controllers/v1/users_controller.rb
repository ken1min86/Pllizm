module V1
  class UsersController < ApplicationController
    before_action :authenticate_v1_user!

    def disable_lock_description
      current_v1_user.update(need_description_about_lock: false)
      render json: current_v1_user, status: :ok
    end
  end
end

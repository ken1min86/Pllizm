class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  # 未対応：APIではCSRFチェックをしないように設定
  skip_before_action :verify_authenticity_token, if: :devise_controller?, raise: false

  private

  def render_json_bad_request_with_custom_errors(title, detail)
    render json: { errors: { title: title, detail: detail } }, status: :bad_request
  end
end

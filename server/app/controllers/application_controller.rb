class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  # 未対応：APIではCSRFチェックをしないように設定
  skip_before_action :verify_authenticity_token, if: :devise_controller?, raise: false

  private

  def render_json_bad_request_with_custom_errors(title, detail)
    render json: { errors: { title: title, detail: detail } }, status: :bad_request
  end

  def render_json_forbitten_with_custom_errors(title, detail)
    render json: { errors: { title: title, detail: detail } }, status: :forbidden
  end

  def verify_refractable_after_authenticate
    not_excuted_refract_of_current_user = CurrentUserRefract.find_by(user_id: current_v1_user.id, performed_refract: false)
    if not_excuted_refract_of_current_user.blank?
      render_json_forbitten_with_custom_errors(
        'リフラクト機能を使用できません',
        'フォロワーが2人未満、またはすでにリフラクト済み、またはリフラクト対象のレコードが存在しません。'
      )
    end
  end

  def restrict_depending_on_whether_user_have_right
    unless current_v1_user.has_right_to_use_pllizm
      render_json_forbitten_with_custom_errors('この機能は利用できません。', 'フォロワーが2人未満であるため、この機能を利用できません。')
    end
  end
end

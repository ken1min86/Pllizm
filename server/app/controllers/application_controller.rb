class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  # APIではCSRFチェックをしないように設定
  skip_before_action :verify_authenticity_token, if: :devise_controller?, raise: false

  #   以下のように、サインアップ時に自動でusernameを設定する用にする
#       また、以下二店もチェックする
#         メアドが正しく入力されているか
#         パスワードが8桁以上でかつ数字と文字が含まれているか
  #   before_action :configre_permitted_parameters, if: :devise_controller?
  # 参考 https://qiita.com/neojin/items/f03d8ebfc2e9e8a31daa
  #   def configre_permitted_parameters
  #     devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  # デフォルトのnameを設定する処理
  #   end
end

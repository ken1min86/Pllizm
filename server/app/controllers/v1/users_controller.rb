module V1
  class UsersController < ApplicationController
    before_action :authenticate_v1_user!

    def disable_lock_description
      current_v1_user.update(need_description_about_lock: false)
      render json: current_v1_user, status: :ok
    end

    def index_of_followers
      followers = current_v1_user.followings
      # followersのうち、仕様書に指定されたカラムだけを抽出して配列に代入する
      extracted_followers = User.extract_disclosable_culumns_from_users_array(followers)
      render json: { users: extracted_followers }, status: :ok
    end

    def index_of_users_follow_requested_by_me
      follow_requested_users = current_v1_user.follow_requesting_users
      # follow_requested_usersのうち、仕様書に指定されたカラムだけを抽出して配列に代入する
      extracted_follow_requested_users = User.extract_disclosable_culumns_from_users_array(follow_requested_users)
      render json: { users: extracted_follow_requested_users }, status: :ok
    end

    def index_of_users_follow_request_to_me
      follow_request_to_me_users = current_v1_user.follow_requesting_to_me_users
      # follow_request_to_me_usersのうち、仕様書に指定されたカラムだけを抽出して配列に代入する
      extracted_follow_request_to_me_users = User.extract_disclosable_culumns_from_users_array(follow_request_to_me_users)
      render json: { users: extracted_follow_request_to_me_users }, status: :ok
    end

    def index_searched_users
      if params[:q].blank?
        render_json_bad_request_with_custom_errors(
          'クエリパラメータが不正です',
          'クエリパラメータに検索したい値を設定してください'
        )
      else
        not_formatted_serached_users = []
        searched_users_by_userid     = User.where("userid LIKE ?", "#{params[:q]}%")
        searched_users_by_username   = User.where("username LIKE ?", "#{params[:q]}%")

        # 一致度を評価する指標として、lengthカラムを追加
        searched_users_by_userid.each do |searched_user_by_userid|
          hashed_searched_user_by_userid          = searched_user_by_userid.attributes.symbolize_keys
          hashed_searched_user_by_userid[:length] = hashed_searched_user_by_userid[:userid].length
          not_formatted_serached_users.push(hashed_searched_user_by_userid)
        end
        searched_users_by_username.each do |searched_user_by_username|
          hashed_searched_user_by_username          = searched_user_by_username.attributes.symbolize_keys
          hashed_searched_user_by_username[:length] = hashed_searched_user_by_username[:username].length
          not_formatted_serached_users.push(hashed_searched_user_by_username)
        end

        # 一致度が高い順にソートし、重複データ削除
        not_formatted_serached_users.sort_by! { |user| user[:length] }
        not_formatted_serached_users.uniq!    { |user| user[:id] }

        # 仕様書通りにフォーマット
        formatted_searched_users = []
        not_formatted_serached_users.each do |not_formatted_serached_user|
          formatted_searched_user = User.format_searched_user(not_formatted_serached_user[:id])
          formatted_searched_users.push(formatted_searched_user)
        end
        render json: { users: formatted_searched_users }, status: :ok
      end
    end

    def show_user_info
      user = User.find_by(userid: params[:id])
      if user.blank?
        render_json_bad_request_with_custom_errors(
          'パラメータのidが不正です',
          'パラメータのidに、実際のユーザに紐づくuseridを設定してください'
        )
      else
        user_info = User.format_user_in_form_of_user_info(
          current_user: current_v1_user,
          not_formatted_user: user
        )
        render json: user_info, status: :ok
      end
    end
  end
end

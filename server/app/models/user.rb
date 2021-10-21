class User < ActiveRecord::Base
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # :confirmable, :omniauthable
  devise :validatable, password_length: 8..128
  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy

  has_many :follow_requests, class_name: 'FollowRequest', foreign_key: 'requested_by', dependent: :destroy
  has_many :follow_requesting_users, through: :follow_requests, source: 'relate_to_request_to_user'

  has_many :reverse_of_follow_requests, class_name: 'FollowRequest', foreign_key: 'request_to', dependent: :destroy
  has_many :follow_requesting_to_me_users, through: :reverse_of_follow_requests, source: 'relate_to_requested_by_user'

  has_many :follow_relationships, class_name: 'Follower', :foreign_key => 'followed_by', dependent: :destroy
  has_many :followings, through: :follow_relationships, source: 'relate_to_follow_to_user'

  has_many :reverse_of_follow_relationships, class_name: 'Follower', :foreign_key => 'follow_to', dependent: :destroy
  has_many :followers, through: :reverse_of_follow_relationships, source: 'relate_to_followed_by_user'

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: 'liked_post'

  has_many :notifications_by_me, class_name: 'Notification', :foreign_key => 'notify_user_id', dependent: :destroy
  has_many :notified_by_me_users, through: :notifications_by_me, source: 'notified_user_id'

  has_many :notifications_to_me, class_name: 'Notification', :foreign_key => 'notified_user_id', dependent: :destroy
  has_many :notified_to_me_users, through: :notifications_to_me, source: 'notify_user_id'

  has_many :current_user_refracts

  has_many :follower_refracts

  validates :userid,   length: { maximum: 15 }, uniqueness: true, presence: true
  validates :username, length: { maximum: 50 }, presence: true
  validates :bio,      length: { maximum: 160 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true, presence: true

  def self.extract_disclosable_culumns_from_users_array(users_array)
    extracted_users = []
    users_array.each do |user|
      extracted_user             = {}
      extracted_user[:user_id]   = user.userid
      extracted_user[:user_name] = user.username
      extracted_user[:icon_url]  = user.image.url
      extracted_user[:bio]       = user.bio
      extracted_users.push(extracted_user)
    end
    extracted_users
  end

  def self.format_searched_user(current_user, not_formatted_searched_user_id)
    not_formatted_serached_user         = User.find(not_formatted_searched_user_id)
    formatted_searched_user             = {}
    formatted_searched_user[:user_id]   = not_formatted_serached_user.userid
    formatted_searched_user[:user_name] = not_formatted_serached_user.username
    formatted_searched_user[:image_url] = not_formatted_serached_user.image.url
    formatted_searched_user[:bio]       = not_formatted_serached_user.bio
    if not_formatted_serached_user.current_user?(current_user)
      formatted_searched_user[:relationship] = 'current_user'
    elsif current_user.following?(not_formatted_serached_user)
      formatted_searched_user[:relationship] = 'following'
    elsif current_user.requested_follow_by_me?(not_formatted_serached_user)
      formatted_searched_user[:relationship] = 'requested_follow_by_me'
    elsif current_user.request_follow_to_me?(not_formatted_serached_user)
      formatted_searched_user[:relationship] = 'request_follow_to_me'
    else
      formatted_searched_user[:relationship] = 'none'
    end
    formatted_searched_user
  end

  # アカウント画面から呼び出されるAPIなどで、アカウント情報を返す場合のフォーマッタ
  def self.format_user_in_form_of_user_info(current_user:, not_formatted_user:)
    user_info = {}
    if not_formatted_user.current_user?(current_user)
      user_info = not_formatted_user.format_current_user_in_form_of_user_info
    else
      user_info = not_formatted_user.format_not_current_user_in_form_of_user_info(current_user)
    end
    user_info
  end

  # アカウント画面から呼び出されるAPIなどで、アカウント情報を返す場合のフォーマッタ
  def format_current_user_in_form_of_user_info
    user_info                               = {}
    user_info[:is_current_user]             = true
    user_info[:icon_url]                    = image.url
    user_info[:user_name]                   = username
    user_info[:user_id]                     = userid
    user_info[:bio]                         = bio
    user_info[:followers_count]             = get_num_of_followers
    user_info[:follow_requests_to_me_count] = get_num_of_follow_requests_to_me
    user_info[:follow_requests_by_me_count] = get_num_of_follow_requests_by_me
    user_info[:following]                   = false
    user_info[:follow_request_sent_to_me]   = false
    user_info[:follow_requet_sent_by_me]    = false
    user_info
  end

  # アカウント画面から呼び出されるAPIなどで、アカウント情報を返す場合のフォーマッタ
  def format_not_current_user_in_form_of_user_info(current_user)
    user_info                               = {}
    user_info[:is_current_user]             = false
    user_info[:icon_url]                    = image.url
    user_info[:user_name]                   = username
    user_info[:user_id]                     = userid
    user_info[:bio]                         = bio
    user_info[:followers_count]             = nil
    user_info[:follow_requests_to_me_count] = nil
    user_info[:follow_requests_by_me_count] = nil
    user_info[:following]                   = current_user.following?(self)
    user_info[:follow_request_sent_to_me]   = requested_follow_by_me?(current_user)
    user_info[:follow_requet_sent_by_me]    = current_user.requested_follow_by_me?(self)
    user_info
  end

  # カレントユーザがフォローリクエストしたユーザのインスタンスに対して使用
  def create_notification_follow_request!(current_user)
    notification = Notification.where(
      notify_user_id: current_user.id,
      notified_user_id: id,
      action: 'request',
    )
    if notification.blank?
      current_user.notifications_by_me.create(
        notified_user_id: id,
        action: 'request',
      )
    end
  end

  # カレントユーザがフォロー承認したユーザのインスタンスに対して使用
  def create_notification_follow_accept!(current_user)
    current_user.notifications_by_me.create(
      notified_user_id: id,
      action: 'accept',
    )
  end

  def current_user?(current_user)
    id == current_user.id
  end

  # 関数名変更する
  def requested_follow_by_me?(other_user)
    follow_requesting_users.include?(other_user)
  end

  def request_follow_to_me?(other_user)
    follow_requesting_to_me_users.include?(other_user)
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def follow(other_user)
    unless self == other_user
      follow_relationship            = follow_relationships.create(follow_to: other_user.id)
      reverse_of_follow_relationship = reverse_of_follow_relationships.create(followed_by: other_user.id)
      [follow_relationship, reverse_of_follow_relationship]
    end
  end

  def get_current_user_refract
    current_user_refracts.find_by(performed_refract: false)
  end

  def get_performed_current_user_refracts
    current_user_refracts.where(performed_refract: true).order(created_at: :desc)
  end

  def get_follower_refracts
    follower_refracts.order(created_at: :desc)
  end

  def get_num_of_followers
    followers.count
  end

  def get_num_of_follow_requests_to_me
    follow_requesting_to_me_users.count
  end

  def get_num_of_follow_requests_by_me
    follow_requesting_users.count
  end

  def has_right_to_use_plizm
    followers.count >= 2
  end
end

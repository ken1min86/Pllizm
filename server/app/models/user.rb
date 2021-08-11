class User < ActiveRecord::Base
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # :confirmable, :omniauthable
  devise :validatable, password_length: 8..128
  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy

  # ****************************************
  # [フォロリク関連でエラーが出た特に以下を確認]
  # has_many :follow_requestsの
  # 名称をfollow_requests以外に変更しないとエラーが発生する可能性あり
  # ****************************************
  has_many :follow_requests, class_name: 'FollowRequest', foreign_key: 'requested_by', dependent: :destroy
  has_many :follow_requesting_users, through: :follow_requests, source: 'relate_to_request_to_user'

  has_many :reverse_of_follow_requests, class_name: 'FollowRequest', foreign_key: 'request_to', dependent: :destroy
  has_many :follow_requesting_to_me_users, through: :reverse_of_follow_requests, source: 'relate_to_requested_by_user'

  has_many :followers, class_name: 'Follower', :foreign_key => 'followed_by', dependent: :destroy
  has_many :followings, through: :followers, source: 'relate_to_follow_to_user'

  has_many :reverse_of_followers, class_name: 'Follower', :foreign_key => 'follow_to', dependent: :destroy
  has_many :followers, through: :reverse_of_followers, source: 'relate_to_followed_by_user'

  validates :userid,   length: { maximum: 15 }, uniqueness: true, presence: true
  validates :username, length: { maximum: 50 }, presence: true
  validates :bio,      length: { maximum: 160 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }, presence: true

  def request_following?(other_user)
    self.follow_requesting_users.include?(other_user)
  end
end

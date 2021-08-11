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
  has_many :follow_requests, class_name: 'FollowRequest', :foreign_key => 'requested_by'
  has_many :request_followings, through: :follow_requests, source: :request_to

  has_many :reverse_of_follow_requests, class_name: 'FollowRequest', :foreign_key => 'request_to'
  has_many :request_followers, through: :follow_requests, source: :requested_by

  has_many :followers, class_name: 'Follower', :foreign_key => 'followed_by'
  has_many :followings, through: :followers, source: :follow_to

  has_many :reverse_of_followers, class_name: 'Follower', :foreign_key => 'follow_to'
  has_many :followers, through: :reverse_of_followers, source: :followed_by

  validates :userid,   length: { maximum: 15 }, uniqueness: true, presence: true
  validates :username, length: { maximum: 50 }, presence: true
  validates :bio,      length: { maximum: 160 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }, presence: true

  # def request_follow(other_user)
  #   if self == other_user
  #     self.errors.add(:request_to, '自分に対するフォローリクエスト')
  #   elsif self.follow_requests.find_by(requested_by: other_user.id)
  #     self.errors.add(:request_to, 'すでにフォローリクエスト済み')
        # 追加：相互フォロアーに対するフォロリクを防ぐ処理
  #   end

  #   unless self == other_user
  #     self.follow_requests.find_or_create_by(request_to: other_user.id)
  #   end
  # end

  # def reject_follow_request(other_user)
  #   relationship = self.relationships.find_by(follow_id: other_user.id)
  #   relationship.destroy if relationship
  # end
end

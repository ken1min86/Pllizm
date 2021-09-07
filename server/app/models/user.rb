class User < ActiveRecord::Base
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # :confirmable, :omniauthable
  devise :validatable, password_length: 8..128
  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy

  # *********************************************************
  # [フォロリク関連でエラーが出た特に以下を確認]
  # has_many :follow_requestsの
  # 名称をfollow_requests以外に変更しないとエラーが発生する可能性あり
  # *********************************************************
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

  has_many :current_user_refracts

  has_many :follower_refracts

  validates :userid,   length: { maximum: 15 }, uniqueness: true, presence: true
  validates :username, length: { maximum: 50 }, presence: true
  validates :bio,      length: { maximum: 160 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }, presence: true

  def self.extract_disclosable_culumns_from_users_array(users_array)
    extracted_users = []
    users_array.each do |user|
      hashed_user         = user.attributes.symbolize_keys
      hashed_user[:image] = user.image.url
      extracted_user      = hashed_user.slice(
        :id,
        :userid,
        :username,
        :image,
        :bio,
        :need_description_about_lock
      )
      extracted_users.push(extracted_user)
    end
    extracted_users
  end

  def request_following?(other_user)
    follow_requesting_users.include?(other_user)
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
end

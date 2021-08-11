class User < ActiveRecord::Base
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # :confirmable, :omniauthable
  devise :validatable, password_length: 8..128
  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy

  has_many :follow_requests, class_name: 'FollowRequest', :foreign_key => 'requested_by'
  has_many :request_followings, through: :follow_requests, source: :request_to

  has_many :reverse_of_follow_requests, class_name: 'FollowRequest', :foreign_key => 'request_to'
  has_many :request_followers, through: :follow_requests, source: :requested_by

  validates :userid,   length: { maximum: 15 }, uniqueness: true, presence: true
  validates :username, length: { maximum: 50 }, presence: true
  validates :bio,      length: { maximum: 160 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }, presence: true
end

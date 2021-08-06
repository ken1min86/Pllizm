class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # :confirmable, :omniauthable
  devise :validatable, password_length: 8..128
  include DeviseTokenAuth::Concerns::User

  validates :userid,   length: { maximum: 15 }, uniqueness: true, presence: true
  validates :username, length: { maximum: 50 }, presence: true
  validates :bio,      length: { maximum: 160 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }, presence: true
end

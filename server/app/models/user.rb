class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # :confirmable, :omniauthable
  devise :validatable, password_length: 8..128

  include DeviseTokenAuth::Concerns::User
  validates :name, length: { maximum: 50 }, presence: true
  validates :bio,  length: { minimum: 1, maximum: 160 }, allow_nil: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }, presence: true
end

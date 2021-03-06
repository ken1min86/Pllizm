class Icon < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :posts

  validates :image, presence: true
end

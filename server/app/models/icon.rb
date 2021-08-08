class Icon < ApplicationRecord
  has_many :posts
  validates :image, presence: true
  mount_uploader :image, IconImageUploader
end

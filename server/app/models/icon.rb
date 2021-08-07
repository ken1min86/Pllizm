class Icon < ApplicationRecord
  validates :image, presence: true
  mount_uploader :image, IconImageUploader
end

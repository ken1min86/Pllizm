require 'securerandom'

class Post < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_one :icon

  validates :content, length: { maximum: 140 }
  validates :image, image_extension: true
  validates :user_id, presence: true
  validates :content, presence: true

  default_scope -> { order(created_at: :desc) }

  before_create :set_id, :set_icon_id

  private
    def set_id
      while self.id.blank? || User.find_by(id: self.id).present? do
        self.id = SecureRandom.alphanumeric(20)
      end
    end

    def set_icon_id
      self.icon_id = Icon.all.sample.id
    end
end

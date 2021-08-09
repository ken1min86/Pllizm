require 'securerandom'

class Post < ApplicationRecord
  acts_as_paranoid
  mount_uploader :image, ImageUploader
  default_scope -> { order(created_at: :desc) }

  belongs_to :user
  has_one :icon

  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true

  before_create :set_id, :set_icon_id

  private

  def set_id
    while id.blank? || User.find_by(id: id).present?
      self.id = SecureRandom.alphanumeric(20)
    end
  end

  def set_icon_id
    self.icon_id = Icon.all.sample.id
  end
end

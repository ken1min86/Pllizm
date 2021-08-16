require 'securerandom'

class Post < ApplicationRecord
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_one :icon

  has_many :tree_paths, class_name: 'TreePath', foreign_key: 'ancestor'
  has_many :descendant_posts, through: :tree_paths, source: 'descendant_post'

  has_many :reverse_of_tree_paths, class_name: 'TreePath', foreign_key: 'descendant'
  has_many :ancestor_posts, through: :reverse_of_tree_paths, source: 'ancestor_post'

  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true

  before_create :set_id, :set_icon_id
  after_create :create_self_referential_tree_paths

  private

  def set_id
    while id.blank? || User.find_by(id: id).present?
      self.id = SecureRandom.alphanumeric(20)
    end
  end

  def set_icon_id
    self.icon_id = Icon.all.sample.id
  end

  def create_self_referential_tree_paths
    TreePath.create(ancestor: self.id, descendant: self.id, depth: 0)
  end
end

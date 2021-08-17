require 'securerandom'

class Post < ApplicationRecord
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_one :icon

  has_many :likes, class_name: 'Like', foreign_key: 'post_id', dependent: :destroy
  has_many :liked_users, through: :likes, source: 'user_id'

  has_many :tree_paths, class_name: 'TreePath', foreign_key: 'ancestor'
  has_many :descendant_posts, through: :tree_paths, source: 'descendant_post'

  has_many :reverse_of_tree_paths, class_name: 'TreePath', foreign_key: 'descendant'
  has_many :ancestor_posts, through: :reverse_of_tree_paths, source: 'ancestor_post'

  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true

  before_create :set_id, :set_icon_id
  after_create :create_self_referential_tree_paths

  def your_post?(current_user)
    user_id == current_user.id
  end

  def mutual_followers_post?(current_user)
    mutual_followers = current_user.followings
    is_mutual_followers_post = false
    mutual_followers.each do |mutual_follower|
      if user_id == mutual_follower.id
        is_mutual_followers_post = true
        break
      end
    end
    is_mutual_followers_post
  end

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
    TreePath.create(ancestor: id, descendant: id, depth: 0)
  end
end

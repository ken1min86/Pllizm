require 'securerandom'

class Post < ApplicationRecord
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  belongs_to :user
  belongs_to :icon

  has_many :likes, class_name: 'Like', foreign_key: 'post_id', dependent: :destroy
  has_many :liked_users, through: :likes, source: 'user'

  has_many :tree_paths, class_name: 'TreePath', foreign_key: 'ancestor'
  has_many :descendant_posts, through: :tree_paths, source: 'descendant_post'

  has_many :reverse_of_tree_paths, class_name: 'TreePath', foreign_key: 'descendant'
  has_many :ancestor_posts, through: :reverse_of_tree_paths, source: 'ancestor_post'

  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true

  before_validation :set_icon_id, on: :create
  before_create     :set_id
  after_create      :create_self_referential_tree_paths

  def self.extract_disclosable_culumns_from_posts_array(posts_array)
    extracted_posts = []
    posts_array.each do |post|
      hashed_post = post.attributes.symbolize_keys
      hashed_post[:image] = post.image.url
      hashed_post.delete(:user_id)
      extracted_posts.push(hashed_post)
    end
    extracted_posts
  end

  def self.extract_root_posts(posts_array)
    root_posts_array = []
    posts_array.each do |post|
      if TreePath.where(descendant: post.id).length == 1
        root_posts_array.push(post)
      end
    end
    root_posts_array
  end

  def format_current_user_post(current_user)
    hashed_current_user_post = attributes.symbolize_keys
    hashed_current_user_post.delete(:user_id)
    hashed_current_user_post.delete(:icon_id)
    hashed_current_user_post[:image]    = image.url
    hashed_current_user_post[:icon_url] = current_user.image.url
    hashed_current_user_post[:userid]   = current_user.userid
    hashed_current_user_post[:username] = current_user.username
    hashed_current_user_post[:likes]    = likes.length
    hashed_current_user_post[:replies]  = count_replies_of_current_user_post(current_user)
    hashed_current_user_post[:is_liked_by_current_user] = is_liked_by_current_user?(current_user)
    hashed_current_user_post[:is_reply] = is_reply?
    formatted_current_user_post = { current_user_post: hashed_current_user_post }
    formatted_current_user_post
  end

  def format_follower_post(current_user)
    hashed_follower_post = attributes.symbolize_keys
    hashed_follower_post.delete(:user_id)
    hashed_follower_post.delete(:icon_id)
    hashed_follower_post[:image]    = image.url
    hashed_follower_post[:icon_url] = icon.image.url
    hashed_follower_post[:replies]  = count_replies_of_follower_post_replied_by_current_user_or_followers(current_user)
    hashed_follower_post[:is_liked_by_current_user] = is_liked_by_current_user?(current_user)
    hashed_follower_post[:is_reply] = is_reply?
    formatted_follower_post = { mutual_follower_post: hashed_follower_post }
    formatted_follower_post
  end

  def is_liked_by_current_user?(current_user)
    is_liked_by_current_user = false
    liked_users.each do |liked_user|
      if liked_user.id == current_user.id
        is_liked_by_current_user = true
        break
      end
    end
    is_liked_by_current_user
  end

  def is_reply?
    TreePath.where(descendant: id).length > 1
  end

  def count_replies_of_current_user_post(current_user)
    num_of_replies_exclude_logically_deleted_posts = 0
    tree_paths_of_replies_include_logically_deleted_posts = TreePath.where(ancestor: id, depth: 1)
    tree_paths_of_replies_include_logically_deleted_posts.each do |tree_path_of_reply_include_logically_deleted_post|
      unless tree_path_of_reply_include_logically_deleted_post.descendant_post.nil?
        num_of_replies_exclude_logically_deleted_posts += 1
      end
    end
    num_of_replies_exclude_logically_deleted_posts
  end

  def count_replies_of_follower_post_replied_by_current_user_or_followers(current_user)
    num_of_replies_exclude_logically_deleted_posts = 0
    followers = current_user.followings
    tree_paths_of_replies_include_logically_deleted_posts = TreePath.where(ancestor: id, depth: 1)
    tree_paths_of_replies_include_logically_deleted_posts.each do |tree_path_of_reply_include_logically_deleted_post|
      unless tree_path_of_reply_include_logically_deleted_post.descendant_post.nil?
        tree_path_of_reply_exclude_logically_deleted_post = tree_path_of_reply_include_logically_deleted_post
        if tree_path_of_reply_exclude_logically_deleted_post.descendant_post.user_id == current_user.id
          num_of_replies_exclude_logically_deleted_posts += 1
        elsif followers.index(tree_path_of_reply_exclude_logically_deleted_post.descendant_post.user)
          num_of_replies_exclude_logically_deleted_posts += 1
        end
      end
    end
    num_of_replies_exclude_logically_deleted_posts
  end

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

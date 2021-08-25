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

  # 【ステータスは以下の5種類】
  # 削除済み:             deleted
  # 存在しない:           not_exist
  # カレントユーザの投稿:   current_user_post
  # 相互フォロワーの投稿:   mutual_follower_post
  # 非相互フォロワーの投稿: not_mutual_follower_post
  def self.check_status_of_current_post(current_user, current_post_id)
    current_post = Post.find_by(id: current_post_id)
    followers = current_user.followings
    status_of_current_post = ''
    if current_post.nil?
      if Post.only_deleted.find_by(id: current_post_id)
        status_of_current_post = Settings.constants.status_of_post[:deleted]
      else
        status_of_current_post = Settings.constants.status_of_post[:not_exist]
      end
    elsif current_post.user == current_user
      status_of_current_post = Settings.constants.status_of_post[:current_user_post]
    elsif followers.index(current_post.user)
      status_of_current_post = Settings.constants.status_of_post[:mutual_follower_post]
    else
      status_of_current_post = Settings.constants.status_of_post[:not_mutual_follower_post]
    end
    status_of_current_post
  end

  def self.get_current_according_to_status_of_current_post(current_user, current_post_id, status_of_current_post)
    current = {}
    if status_of_current_post == Settings.constants.status_of_post[:current_user_post]
      current_post_of_current_user = Post.find(current_post_id)
      formatted_current_post_of_current_user = current_post_of_current_user.format_current_user_post(current_user)
      current.merge!(formatted_current_post_of_current_user)

    elsif status_of_current_post == Settings.constants.status_of_post[:mutual_follower_post]
      current_post_of_follower = Post.find(current_post_id)
      formatted_current_post_of_follower = current_post_of_follower.format_follower_post(current_user)
      current.merge!(formatted_current_post_of_follower)
    elsif status_of_current_post == Settings.constants.status_of_post[:not_mutual_follower_post]
      current[:not_mutual_follower_post] = nil
    elsif status_of_current_post == Settings.constants.status_of_post[:deleted]
      current[:deleted] = nil
    elsif status_of_current_post == Settings.constants.status_of_post[:not_exist]
      current[:not_exist] = nil
    end
    current
  end

  def self.get_parent_of_current_post(current_user, current_post_id)
    parent = {}
    followers = current_user.followings
    tree_path_of_parent_post = TreePath.find_by(descendant: current_post_id, depth: 1)
    if tree_path_of_parent_post.nil?
      parent[:not_exist] = nil
    else
      parent_post = Post.find_by(id: tree_path_of_parent_post.ancestor)
      if parent_post.nil?
        parent[:deleted] = nil
      elsif parent_post.user == current_user
        parent_post_of_current_user = tree_path_of_parent_post.ancestor_post
        formatted_parent_post_of_current_user = parent_post_of_current_user.format_current_user_post(current_user)
        parent.merge!(formatted_parent_post_of_current_user)
      elsif followers.index(parent_post.user)
        parent_post_of_follower = tree_path_of_parent_post.ancestor_post
        formatted_parent_post_of_follower = parent_post_of_follower.format_follower_post(current_user)
        parent.merge!(formatted_parent_post_of_follower)
      else
        parent[:not_mutual_follower_post] = nil
      end
    end
    parent
  end

  def self.get_children_of_current_post(current_user, current_post_id)
    tree_path_of_children_posts = TreePath.where(ancestor: current_post_id, depth: 1)
    children = []
    if tree_path_of_children_posts.length > 0
      # カレントの投稿の子の投稿のうち、非相互フォロワーの投稿を除く
      children_posts_of_current_user_or_mutual_follower = []
      tree_path_of_children_posts.each do |tree_path_of_children_post|
        children_post = tree_path_of_children_post.descendant_post
        if children_post.your_post?(current_user) || children_post.mutual_followers_post?(current_user)
          children_posts_of_current_user_or_mutual_follower.push(children_post)
        end
      end

      if children_posts_of_current_user_or_mutual_follower.empty?
        children.push({ not_exist: nil })
      else
        children_posts_of_current_user_or_mutual_follower.sort_by! { |post| post["created_at"] }.reverse!
        children_posts_of_current_user_or_mutual_follower.each do |children_post|
          if children_post.your_post?(current_user)
            formatted_children_post_of_current_user = children_post.format_current_user_post(current_user)
            children.push(formatted_children_post_of_current_user)
          # フォロワーの投稿だった場合
          else
            formatted_children_post_of_mutual_follower = children_post.format_follower_post(current_user)
            children.push(formatted_children_post_of_mutual_follower)
          end
        end
      end
    else
      children.push({ not_exist: nil })
    end
    children
  end

  # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
  # パターンA: ルートがカレントユーザの投稿であり、
  #           子以下がカレントユーザ以外の投稿である場合
  # パターンB: ルートへのリプライにカレントユーザの投稿を含み、
  #           リーフがカレントユーザの投稿の場合
  # パターンC: ルートへのリプライにカレントユーザの投稿を含み、
  #           リーフがカレントユーザの投稿以外の場合
  # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
  def self.get_reply(current_user, current_user_post_with_deleted)
    reply = []
    tree_paths_except_current_post_depth_0 = TreePath.where.not(ancestor: current_user_post_with_deleted.id,
                                                                descendant: current_user_post_with_deleted.id, depth: 0)
    tree_paths_below_child_post = tree_paths_except_current_post_depth_0.where(ancestor: current_user_post_with_deleted.id)
    tree_paths_above_parent_post = tree_paths_except_current_post_depth_0.where(descendant: current_user_post_with_deleted.id)
    # *********************************************
    # パターンA
    if tree_paths_below_child_post.length > 0 && tree_paths_above_parent_post.length == 0
      has_current_post_below_child = false
      unless current_user_post_with_deleted.is_deleted?
        tree_paths_below_child_post.each do |tree_path_below_current_post|
          posts_below_current_post = Post.with_deleted.find(tree_path_below_current_post.descendant)
          if posts_below_current_post.your_post?(current_user)
            has_current_post_below_child = true
            break
          end
        end
        if has_current_post_below_child == false
          tree_paths_of_children = TreePath.where(ancestor: current_user_post_with_deleted.id, depth: 1)
          tree_paths_of_children.each do |tree_path_of_child|
            child_post = Post.with_deleted.find(tree_path_of_child.descendant)
            unless child_post.is_deleted?
              if child_post.mutual_followers_post?(current_user)
                reply.push(current_user_post_with_deleted.format_current_user_post(current_user))
                break
              end
            end
          end
        end
      end
    # *********************************************
    # パターンB and C
    elsif tree_paths_above_parent_post.length > 0
      has_curret_post_below_child = false
      tree_paths_below_child_post.each do |tree_path_below_child_post|
        post_below_child = Post.with_deleted.find(tree_path_below_child_post.descendant)
        if post_below_child.your_post?(current_user)
          has_curret_post_below_child = true
          break
        end
      end
      unless has_curret_post_below_child
        if current_user_post_with_deleted.is_deleted?
          has_parent = true
          while has_parent
            tree_path_of_parent = TreePath.find_by(descendant: current_user_post_with_deleted.id, depth: 1)
            if tree_path_of_parent.blank?
              has_parent = false
            else
              parent_post = Post.with_deleted.find(tree_path_of_parent.ancestor)
              if !parent_post.is_deleted? && parent_post.your_post?(current_user)
                if TreePath.where(descendant: parent_post).length > 1
                  reply.push(parent_post.format_current_user_post(current_user))
                  has_parent = false
                else
                  tree_paths_of_children = TreePath.where(ancestor: parent_post)
                  tree_paths_of_children.each do |tree_path_of_child|
                    child_post = Post.with_deleted.find(tree_path_of_child.descendant)
                    unless child_post.is_deleted?
                      if child_post.mutual_followers_post?(current_user)
                        reply.push(parent_post.format_current_user_post(current_user))
                        has_parent = false
                        break
                      end
                    end
                  end
                  if has_parent
                    current_user_post_with_deleted = parent_post
                  end
                end
              else
                current_user_post_with_deleted = parent_post
              end
            end
          end
        else
          reply.push(current_user_post_with_deleted.format_current_user_post(current_user))
        end
      end
    end
    reply
  end

  def format_current_user_post(current_user)
    hashed_current_user_post = attributes.symbolize_keys
    hashed_current_user_post.delete(:user_id)
    hashed_current_user_post.delete(:icon_id)
    hashed_current_user_post[:image]                    = image.url
    hashed_current_user_post[:icon_url]                 = current_user.image.url
    hashed_current_user_post[:userid]                   = current_user.userid
    hashed_current_user_post[:username]                 = current_user.username
    hashed_current_user_post[:likes]                    = likes.length
    hashed_current_user_post[:is_liked_by_current_user] = is_liked_by_current_user?(current_user)
    hashed_current_user_post[:is_reply]                 = is_reply?
    hashed_current_user_post[:replies]                  = count_replies_of_current_user_post(current_user)
    formatted_current_user_post                         = { current_user_post: hashed_current_user_post }
    formatted_current_user_post
  end

  def format_follower_post(current_user)
    hashed_follower_post = attributes.symbolize_keys
    hashed_follower_post.delete(:user_id)
    hashed_follower_post.delete(:icon_id)
    hashed_follower_post[:image]                    = image.url
    hashed_follower_post[:icon_url]                 = icon.image.url
    hashed_follower_post[:is_liked_by_current_user] = is_liked_by_current_user?(current_user)
    hashed_follower_post[:is_reply]                 = is_reply?
    hashed_follower_post[:replies] = count_replies_of_follower_post_replied_by_current_user_or_followers(current_user)
    formatted_follower_post = { mutual_follower_post: hashed_follower_post }
    formatted_follower_post
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

  def is_deleted?
    if deleted_at.nil?
      false
    else
      true
    end
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

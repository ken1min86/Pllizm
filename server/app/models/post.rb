require 'securerandom'

class Post < ApplicationRecord
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  belongs_to :user
  belongs_to :icon

  has_many :likes,       class_name: 'Like', foreign_key: 'post_id', dependent: :destroy
  has_many :liked_users, through:    :likes, source: 'user'

  has_many :current_user_refracts, class_name: 'CurrentUserRefract', foreign_key: 'post_id'

  has_many :follower_refracts, class_name: 'FollowerRefract', foreign_key: 'post_id'

  has_many :notifications, class_name: 'Notification', foreign_key: 'post_id'

  has_many :tree_paths,       class_name: 'TreePath',  foreign_key: 'ancestor'
  has_many :descendant_posts, through:    :tree_paths, source:      'descendant_post'

  has_many :reverse_of_tree_paths, class_name: 'TreePath',             foreign_key: 'descendant'
  has_many :ancestor_posts,        through:    :reverse_of_tree_paths, source:      'ancestor_post'

  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true

  before_validation :set_icon_id, on: :create
  before_create     :set_id
  after_create      :create_self_referential_tree_paths

  # 【用語定義】
  # - above ~: "~ 以上"の意味。例えば、tree_paths_above_parent_postの場合は、親以上投稿に紐づくTreePathを示す。
  # - below ~: "~ 以下"の意味。例えば、tree_path_below_currentの場合は、カレント以下の投稿に紐づくTreePathを示す。

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
  # 相互フォロワーの投稿:   follower_post
  # 非相互フォロワーの投稿: not_follower_post
  def self.check_status_of_post(current_user, post_id)
    post = Post.with_deleted.find_by(id: post_id)
    status_of_post = ''
    if post.blank?
      status_of_post = Settings.constants.status_of_post[:not_exist]
    elsif post.deleted?
      status_of_post = Settings.constants.status_of_post[:deleted]
    elsif post.your_post?(current_user)
      status_of_post = Settings.constants.status_of_post[:current_user_post]
    elsif post.followers_post?(current_user)
      status_of_post = Settings.constants.status_of_post[:follower_post]
    else
      status_of_post = Settings.constants.status_of_post[:not_follower_post]
    end
    status_of_post
  end

  def self.get_current_according_to_status_of_current_post(current_user, current_post_id, status_of_current_post)
    current = {}
    case status_of_current_post

    when Settings.constants.status_of_post[:current_user_post]
      current_post_of_current_user           = Post.find(current_post_id)
      formatted_current_post_of_current_user = current_post_of_current_user.format_current_user_post(current_user)
      current.merge!(formatted_current_post_of_current_user)

    when Settings.constants.status_of_post[:follower_post]
      current_post_of_follower           = Post.find(current_post_id)
      formatted_current_post_of_follower = current_post_of_follower.format_follower_post(current_user)
      current.merge!(formatted_current_post_of_follower)

    when Settings.constants.status_of_post[:not_follower_post]
      current[:not_follower_post] = nil

    when Settings.constants.status_of_post[:deleted]
      current[:deleted] = nil

    when Settings.constants.status_of_post[:not_exist]
      current[:not_exist] = nil
    end

    current
  end

  def self.get_parent_of_current_post(current_user, current_post_id)
    parent = {}
    tree_path_of_parent_post = TreePath.find_by(descendant: current_post_id, depth: 1)
    if tree_path_of_parent_post.blank?
      parent[:not_exist] = nil
    else
      parent_post = Post.find_by(id: tree_path_of_parent_post.ancestor)
      if parent_post.blank?
        parent[:deleted] = nil
      elsif parent_post.your_post?(current_user) || parent_post.followers_post?(current_user)
        parent_post           = tree_path_of_parent_post.ancestor_post
        formatted_parent_post = parent_post.format_post(current_user)
        parent.merge!(formatted_parent_post)
      else
        parent[:not_follower_post] = nil
      end
    end
    parent
  end

  def self.get_children_of_current_post(current_user, current_post_id)
    children                    = []
    tree_path_of_children_posts = TreePath.where(ancestor: current_post_id, depth: 1)
    if tree_path_of_children_posts.length > 0
      # カレントの投稿の子の投稿のうち、非相互フォロワーの投稿を除く
      children_posts_of_current_user_or_follower = []
      tree_path_of_children_posts.each do |tree_path_of_children_post|
        children_post = tree_path_of_children_post.descendant_post
        if children_post.your_post?(current_user) || children_post.followers_post?(current_user)
          children_posts_of_current_user_or_follower.push(children_post)
        end
      end

      if children_posts_of_current_user_or_follower.empty?
        children.push({ not_exist: nil })
      else
        children_posts_of_current_user_or_follower.sort_by! { |post| post["created_at"] }.reverse!
        children_posts_of_current_user_or_follower.each do |children_post|
          formatted_children_post = children_post.format_post(current_user)
          children.push(formatted_children_post)
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
  # Issue #100
  # ネストが深く処理が理解しづらいため、浅くなるようにリファクタリングする。
  # また、適宜コメントを追加するなどして、理解がしやすくなるように工夫をする。
  # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
  def self.get_reply(current_user, current_user_post_with_deleted)
    reply = nil
    tree_paths_below_child_post = TreePath.where(ancestor: current_user_post_with_deleted.id).where.not(depth: 0)
    tree_paths_above_parent_post = TreePath.where(descendant: current_user_post_with_deleted.id).where.not(depth: 0)
    # *********************************************
    # パターンAのルートを取得
    if tree_paths_below_child_post.length > 0 && tree_paths_above_parent_post.length == 0
      has_current_post_below_child = false
      unless current_user_post_with_deleted.deleted?
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
            unless child_post.deleted?
              if child_post.followers_post?(current_user)
                reply = current_user_post_with_deleted
                break
              end
            end
          end
        end
      end
    # **************************************************************
    # パターンBのリーフの取得 and Cのリーフに一番近いカレントユーザの投稿の取得
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
        if current_user_post_with_deleted.deleted?
          has_parent = true
          while has_parent
            tree_path_of_parent = TreePath.find_by(descendant: current_user_post_with_deleted.id, depth: 1)
            if tree_path_of_parent.blank?
              has_parent = false
            else
              parent_post = Post.with_deleted.find(tree_path_of_parent.ancestor)
              if !parent_post.deleted? && parent_post.your_post?(current_user)
                if TreePath.where(descendant: parent_post).length > 1
                  reply = parent_post
                  has_parent = false
                else
                  tree_paths_of_children = TreePath.where(ancestor: parent_post)
                  tree_paths_of_children.each do |tree_path_of_child|
                    child_post = Post.with_deleted.find(tree_path_of_child.descendant)
                    unless child_post.deleted?
                      if child_post.followers_post?(current_user)
                        reply = parent_post
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
          reply = current_user_post_with_deleted
        end
      end
    end
    reply
  end

  # 返り値は、Postレコードがハッシュ化されているだけでなく、ソート用の'datetime_for_sort'カラムが追加されている点に注意
  def self.get_hashed_refract_candidates_of_like(current_user, target_datetime_from, target_datetime_to)
    refract_candidates_of_like = []
    likes = Like.where(user_id: current_user.id, created_at: target_datetime_from...target_datetime_to)
    likes.each do |like|
      liked_post = like.liked_post
      if !liked_post.is_locked && liked_post.followers_post?(current_user)
        hased_liked_post                     = liked_post.attributes.symbolize_keys
        hased_liked_post[:datetime_for_sort] = like.created_at
        refract_candidates_of_like.push(hased_liked_post)
      end
    end
    refract_candidates_of_like
  end

  # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
  # Issue #100
  # 処理が理解しづらいため、理解がしやすくなるようにリファクタリングする。
  # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
  # 返り値は、Postレコードがハッシュ化されているだけでなく、ソート用の'datetime_for_sort'カラムが追加されている点に注意
  def self.get_hashed_refract_candidates_of_reply(current_user, target_time_from, target_time_to, replies)
    # リプライに紐づくリーフの投稿を取得
    leaves = []
    refract_candidates_of_reply = []
    replies.each do |reply|
      leaves.concat(reply.get_leaves)
    end

    # 以下の条件を満たす、リーフに一番近い投稿を取得
    #  -作成日が対象期間内
    #  -その投稿とその投稿の親以上の(削除されていない)投稿が1つもロックされていない
    #  -削除されていない
    #  -フォロワーの投稿
    #  -カレントユーザの投稿だった場合、親以上に削除されていないフォロワーの投稿を持つ
    #  -フォロワーの投稿だった場合、親以上に削除されていないカレントユーザの投稿を持つ
    leaves.each do |leaf|
      checked_lock    = false
      has_locked_post = false
      while true
        # 作成日が対象期間内かチェック
        if !(target_time_from <= leaf.created_at) || !(leaf.created_at < target_time_to)
          break
        end

        # カレント以上の投稿に、ロックされた投稿が存在するか否かチェック。実行は各leafで1回のみで良い。
        if checked_lock == false
          above_current_posts = leaf.ancestor_posts
          above_current_posts.each do |above_current_post|
            if above_current_post.is_locked == true
              has_locked_post = true
              break
            end
          end
          checked_lock = true
        end
        if has_locked_post == true
          break
        end

        # leafが以下の条件を満たすかチェック
        #  -削除されていない
        #  -フォロワーの投稿
        #  -カレントユーザの投稿だった場合、親以上に削除されていないフォロワーの投稿を持つ
        #  -フォロワーの投稿だった場合、親以上に削除されていないカレントユーザの投稿を持つ
        if !leaf.deleted? && !leaf.not_follower_post?(current_user) && leaf.is_reply?
          if leaf.your_post?(current_user) && leaf.has_not_deleted_post_of_follower_above_parent?(current_user)
            hashed_leaf                     = leaf.attributes.symbolize_keys
            hashed_leaf[:datetime_for_sort] = leaf.created_at
            refract_candidates_of_reply.push(hashed_leaf)
          elsif leaf.followers_post?(current_user) && leaf.has_not_deleted_post_of_current_user_above_parent?(current_user)
            hashed_leaf                     = leaf.attributes.symbolize_keys
            hashed_leaf[:datetime_for_sort] = leaf.created_at
            refract_candidates_of_reply.push(hashed_leaf)
          end
          break
        else
          unless leaf.is_reply?
            break
          end
          leaf = leaf.get_parent_post_with_deleted
        end
      end
    end
    refract_candidates_of_reply.uniq!
    refract_candidates_of_reply
  end

  # 返り値はハッシュ化したPostレコードでかつ、ソート用のdatetime_for_sortカラムが追加されている点に注意
  def self.get_not_formatted_refract_candidates(current_user)
    # リフラクト候補取得の対象期間の取得
    target_time_from, target_time_to = CurrentUserRefract.get_target_times_of_refract(current_user)

    # いいねした投稿の中からリフラクト候補を取得
    hashed_refract_candidates_of_like = Post.get_hashed_refract_candidates_of_like(
      current_user,
      target_time_from,
      target_time_to
    )

    # リプライの中からリフラクト候補を取得
    replies = []
    current_user_posts_with_deleted = Post.with_deleted.where(user_id: current_user.id)
    current_user_posts_with_deleted.each do |current_user_post_with_deleted|
      reply = Post.get_reply(current_user, current_user_post_with_deleted)
      if reply.present?
        replies.push(reply)
      end
    end
    hashed_refract_candidates_of_reply = Post.get_hashed_refract_candidates_of_reply(
      current_user,
      target_time_from,
      target_time_to,
      replies
    )
    # Issue #110 いいねした投稿とリプライの投稿が重複した場合は、リプライの投稿のみ返すよう修正する。
    [hashed_refract_candidates_of_like, hashed_refract_candidates_of_reply]
  end

  # ステータスは本来5種類あるが、いいねした投稿をリフラクトした場合、
  # あり得るステータスは以下3種類のみなので、それらに関してのみ扱う。
  # - 削除済み:             deleted
  # - 非相互フォロワーの投稿: not_follower_post
  # - 相互フォロワーの投稿:   follower_post
  def self.format_refracted_by_me_post_of_like(current_user, liked_post, refracted_at)
    formatted_refracted_post = {}
    status                   = Post.check_status_of_post(current_user, liked_post.id)
    case status
    when Settings.constants.status_of_post[:deleted]
      formatted_refracted_post = {
        refracted_at: I18n.l(refracted_at),
        posts: [deleted: nil],
      }
    when Settings.constants.status_of_post[:not_follower_post]
      formatted_refracted_post = {
        refracted_at: I18n.l(refracted_at),
        posts: [not_follower_post: nil],
      }
    when Settings.constants.status_of_post[:follower_post]
      formatted_refracted_post = {
        refracted_at: I18n.l(refracted_at),
        posts: [liked_post.format_follower_refracted_post(current_user, refracted_at)],
      }
    end
    formatted_refracted_post
  end

  # ステータスは本来5種類あるが、いいねした投稿をリフラクトした場合、
  # あり得るステータスは以下4種類のみなので、それらに関してのみ扱う。
  # - 削除済み:             deleted
  # - 非相互フォロワーの投稿: not_follower_post
  # - カレントユーザの投稿:   current_user_post
  # - 相互フォロワーの投稿:   follower_post
  def self.format_refracted_by_me_posts_of_reply(current_user, replied_leaf_post, refracted_at)
    array_of_formatted_refracted_posts = []
    tree_paths_above_current_post      = TreePath.where(descendant: replied_leaf_post).order(depth: :desc)

    tree_paths_above_current_post.each do |tree_path_above_current_post|
      post   = Post.with_deleted.find(tree_path_above_current_post.ancestor)
      status = Post.check_status_of_post(current_user, post.id)

      case status
      when Settings.constants.status_of_post[:deleted]
        array_of_formatted_refracted_posts.push({ deleted: nil })

      when Settings.constants.status_of_post[:not_follower_post]
        array_of_formatted_refracted_posts.push({ not_follower_post: nil })

      when Settings.constants.status_of_post[:current_user_post]
        formatted_current_user_post = post.format_current_user_refracted_post(current_user, refracted_at)
        array_of_formatted_refracted_posts.push(formatted_current_user_post)

      when Settings.constants.status_of_post[:follower_post]
        formatted_follower_post = post.format_follower_refracted_post(current_user, refracted_at)
        array_of_formatted_refracted_posts.push(formatted_follower_post)
      end
    end

    formatted_refracted_posts = { refracted_at: I18n.l(refracted_at), posts: array_of_formatted_refracted_posts }
    formatted_refracted_posts
  end

  # ステータスは本来5種類あるが、いいねした投稿をリフラクトされた場合、
  # あり得るステータスは以下2種類のみなので、それらに関してのみ扱う。
  # - 削除済み:           deleted
  # - カレントユーザの投稿: current_user_post
  def self.format_refracted_by_follower_post_of_like(current_user:, refracted_by:, liked_post:, refracted_at:)
    formatted_refracted_post = {}
    status                   = Post.check_status_of_post(current_user, liked_post.id)

    case status
    when Settings.constants.status_of_post[:deleted]
      formatted_refracted_post = {
        refracted_at: I18n.l(refracted_at),
        posts: [deleted: nil],
        refracted_by: Post.create_hash_of_refracted_by_to_format_refract(refracted_by),
      }

    when Settings.constants.status_of_post[:current_user_post]
      formatted_refracted_post = {
        refracted_at: I18n.l(refracted_at),
        posts: [liked_post.format_current_user_refracted_post(current_user, refracted_at)],
        refracted_by: Post.create_hash_of_refracted_by_to_format_refract(refracted_by),
      }
    end

    formatted_refracted_post
  end

  # ステータスは本来5種類あるが、リプライをリフラクトされた場合、
  # あり得るステータスは以下4種類のみなので、それらに関してのみ扱う。
  # - 削除済み:             deleted
  # - 非相互フォロワーの投稿: not_follower_post
  # - カレントユーザの投稿:   current_user_post
  # - 相互フォロワーの投稿:   follower_post
  def self.format_refracted_by_follower_posts_of_reply(current_user:, refracted_by:, replied_leaf_post:, refracted_at:)
    array_of_formatted_refracted_posts = []
    tree_paths_above_current_post      = TreePath.where(descendant: replied_leaf_post).order(depth: :desc)

    tree_paths_above_current_post.each do |tree_path_above_current_post|
      post   = Post.with_deleted.find(tree_path_above_current_post.ancestor)
      status = Post.check_status_of_post(current_user, post.id)

      case status
      when Settings.constants.status_of_post[:deleted]
        array_of_formatted_refracted_posts.push({ deleted: nil })

      when Settings.constants.status_of_post[:not_follower_post]
        array_of_formatted_refracted_posts.push({ other_users_post: nil })

      when Settings.constants.status_of_post[:current_user_post]
        formatted_current_user_post = post.format_current_user_refracted_post(current_user, refracted_at)
        array_of_formatted_refracted_posts.push(formatted_current_user_post)

      when Settings.constants.status_of_post[:follower_post]
        if post.user_id == refracted_by.id
          formatted_follower_post = post.format_follower_refracted_post(current_user, refracted_at)
          array_of_formatted_refracted_posts.push(formatted_follower_post)

        else
          array_of_formatted_refracted_posts.push({ other_users_post: nil })
        end
      end
    end

    formatted_refracted_posts = {
      refracted_at: I18n.l(refracted_at),
      posts: array_of_formatted_refracted_posts,
      refracted_by: Post.create_hash_of_refracted_by_to_format_refract(refracted_by),
    }
    formatted_refracted_posts
  end

  # リフラクトした or リフラクトされた投稿をクライアントに返す時に設定する、
  # refracted_byキーに紐づくハッシュデータの作成
  def self.create_hash_of_refracted_by_to_format_refract(refracted_by)
    { userid: refracted_by.userid, username: refracted_by.username }
  end

  # リフラクトした or リフラクトされた投稿"以外"をクライアントに返す際に使用するフォーマッタ
  def format_post(current_user)
    if your_post?(current_user)
      formated_post = format_current_user_post(current_user)
    elsif followers_post?(current_user)
      formated_post = format_follower_post(current_user)
    end
    formated_post
  end

  # リフラクトした or リフラクトされた投稿"以外"をクライアントに返す際に使用するフォーマッタ
  def format_current_user_post(current_user)
    hashed_current_user_post = attributes.symbolize_keys
    hashed_current_user_post.delete(:user_id)
    hashed_current_user_post.delete(:icon_id)
    hashed_current_user_post[:created_at]               = I18n.l(created_at)
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

  # リフラクトした or リフラクトされた投稿"以外"をクライアントに返す際に使用するフォーマッタ
  def format_follower_post(current_user)
    hashed_follower_post = attributes.symbolize_keys
    hashed_follower_post.delete(:user_id)
    hashed_follower_post.delete(:icon_id)
    hashed_follower_post[:created_at]               = I18n.l(created_at)
    hashed_follower_post[:image]                    = image.url
    hashed_follower_post[:icon_url]                 = icon.image.url
    hashed_follower_post[:is_liked_by_current_user] = is_liked_by_current_user?(current_user)
    hashed_follower_post[:is_reply]                 = is_reply?
    hashed_follower_post[:replies] = count_replies_of_follower_post_replied_by_current_user_or_followers(current_user)
    formatted_follower_post = { follower_post: hashed_follower_post }
    formatted_follower_post
  end

  # リフラクトした or リフラクトされた投稿をクライアントに返す際に使用するフォーマッタ
  def format_follower_refracted_post(current_user, refracted_at)
    follower    = user
    hashed_post = attributes.symbolize_keys
    hashed_post.delete(:icon_id)
    hashed_post[:created_at]               = I18n.l(created_at)
    hashed_post[:image]                    = image.url
    hashed_post[:icon_url]                 = follower.image.url
    hashed_post[:userid]                   = follower.userid
    hashed_post[:username]                 = follower.username
    hashed_post[:is_liked_by_current_user] = is_liked_by_current_user?(current_user)
    hashed_post[:is_reply]                 = is_reply?
    hashed_post[:replies]                  = count_replies_of_follower_post_replied_by_current_user_or_followers(current_user)
    refracted_follower_post                = { follower_post: hashed_post }
    refracted_follower_post
  end

  # リフラクトした or リフラクトされた投稿をクライアントに返す際に使用するフォーマッタ
  def format_current_user_refracted_post(current_user, refracted_at)
    hashed_post = attributes.symbolize_keys
    hashed_post.delete(:icon_id)
    hashed_post[:created_at]               = I18n.l(created_at)
    hashed_post[:image]                    = image.url
    hashed_post[:icon_url]                 = current_user.image.url
    hashed_post[:userid]                   = current_user.userid
    hashed_post[:username]                 = current_user.username
    hashed_post[:is_liked_by_current_user] = is_liked_by_current_user?(current_user)
    hashed_post[:is_reply]                 = is_reply?
    hashed_post[:likes]                    = likes.length
    hashed_post[:replies]                  = count_replies_of_current_user_post(current_user)
    refracted_current_user_post            = { current_user_post: hashed_post }
    refracted_current_user_post
  end

  def count_replies_of_current_user_post(current_user)
    num_of_replies_exclude_logically_deleted_posts        = 0
    tree_paths_of_replies_include_logically_deleted_posts = TreePath.where(ancestor: id, depth: 1)
    tree_paths_of_replies_include_logically_deleted_posts.each do |tree_path_of_reply|
      if tree_path_of_reply.descendant_post.present?
        num_of_replies_exclude_logically_deleted_posts += 1
      end
    end
    num_of_replies_exclude_logically_deleted_posts
  end

  def count_replies_of_follower_post_replied_by_current_user_or_followers(current_user)
    num_of_replies_exclude_logically_deleted_posts = 0
    tree_paths_of_replies_include_logically_deleted_posts = TreePath.where(ancestor: id, depth: 1)
    tree_paths_of_replies_include_logically_deleted_posts.each do |tree_path_of_reply|
      reply = tree_path_of_reply.descendant_post
      if reply.present?
        if reply.your_post?(current_user)
          num_of_replies_exclude_logically_deleted_posts += 1
        elsif reply.followers_post?(current_user)
          num_of_replies_exclude_logically_deleted_posts += 1
        end
      end
    end
    num_of_replies_exclude_logically_deleted_posts
  end

  def get_parent_post_with_deleted
    if is_reply?
      tree_path_of_parent = TreePath.find_by(descendant: id, depth: 1)
      parent_post         = Post.with_deleted.find(tree_path_of_parent.ancestor)
      parent_post
    else
      nil
    end
  end

  def has_not_deleted_post_of_current_user_above_parent?(current_user)
    has_not_deleted_post_of_current_user_above_parent = false
    posts_above_parent = ancestor_posts.where.not(id: id)
    posts_above_parent.each do |post_above_parent|
      if post_above_parent.your_post?(current_user)
        has_not_deleted_post_of_current_user_above_parent = true
        break
      end
    end
    has_not_deleted_post_of_current_user_above_parent
  end

  def has_not_deleted_post_of_follower_above_parent?(current_user)
    has_not_deleted_post_of_follower_above_parent = false
    posts_above_parent = ancestor_posts.where.not(id: id)
    posts_above_parent.each do |post_above_parent|
      if post_above_parent.followers_post?(current_user)
        has_not_deleted_post_of_follower_above_parent = true
        break
      end
    end
    has_not_deleted_post_of_follower_above_parent
  end

  def get_leaves
    leaves                   = []
    tree_paths_below_current = TreePath.where(ancestor: id)
    below_current_posts      = []
    tree_paths_below_current.each do |tree_path_below_current|
      below_current_posts.push(Post.with_deleted.find(tree_path_below_current.descendant))
    end
    below_current_posts.each do |below_current_post|
      if TreePath.where(ancestor: below_current_post.id, depth: 1).length == 0
        leaves.push(below_current_post)
      end
    end
    leaves
  end

  # 使用方法: いいねした投稿のインスタンスに対して実行する
  def create_notification_like!(current_user)
    notification = Notification.where(
      notify_user_id: current_user.id,
      notified_user_id: user_id,
      post_id: id,
      action: 'like',
    )
    # いいねを連打された時の対策として、一度もいいねしていない場合のみ通知レコードを作成
    # また、自分の投稿をいいねした場合は通知する必要がないため、通知レコードを作成しない
    if notification.blank? && followers_post?(current_user)
      current_user.notifications_by_me.create(
        notified_user_id: user_id,
        post_id: id,
        action: 'like',
      )
    end
  end

  # 使用方法: リプライに該当する投稿のインスタンスに対して実行する
  # 仕様:     リプライした投稿以上の投稿の投稿主のうち、フォロワーに対してのみ通知レコードを作成する
  def create_notification_reply!(current_user)
    tree_paths_above_parent_of_reply             = TreePath.where(descendant: id).where.not(depth: 0)
    followers_posted_posts_above_parent_of_reply = []
    tree_paths_above_parent_of_reply.each do |tree_path|
      post_above_parent_of_reply = tree_path.ancestor_post
      if post_above_parent_of_reply.present? && post_above_parent_of_reply.followers_post?(current_user)
        followers_posted_posts_above_parent_of_reply.push(post_above_parent_of_reply.user)
      end
    end
    followers_posted_posts_above_parent_of_reply.uniq!
    followers_posted_posts_above_parent_of_reply.each do |follower|
      current_user.notifications_by_me.create(
        notified_user_id: follower.id,
        post_id: id,
        action: 'reply',
      )
    end
  end

  # 使用方法: リフラクトした、いいねの投稿のインスタンスに対して実行する
  def create_notification_refract_when_refracted_like!(current_user)
    current_user.notifications_by_me.create(
      notified_user_id: user_id,
      post_id: id,
      action: 'refract',
    )
  end

  # 使用方法: リフラクトした、リプライに該当する投稿のインスタンスに対して実行する
  def create_notification_refract_when_refracted_reply!(current_user, notified_user_id)
    current_user.notifications_by_me.create(
      notified_user_id: notified_user_id,
      post_id: id,
      action: 'refract',
    )
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

  def your_post?(current_user)
    user_id == current_user.id
  end

  def followers_post?(current_user)
    followers         = current_user.followings
    is_followers_post = false
    followers.each do |follower|
      if user_id == follower.id
        is_followers_post = true
        break
      end
    end
    is_followers_post
  end

  def not_follower_post?(current_user)
    if your_post?(current_user) || followers_post?(current_user)
      false
    else
      true
    end
  end

  private

  def set_id
    while id.blank? || Post.find_by(id: id).present?
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

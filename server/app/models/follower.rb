class Follower < ApplicationRecord
  belongs_to :relate_to_follow_to_user,   class_name: 'User', foreign_key: 'follow_to'
  belongs_to :relate_to_followed_by_user, class_name: 'User', foreign_key: 'followed_by'

  validates :follow_to,   presence: true
  validates :followed_by, presence: true
end

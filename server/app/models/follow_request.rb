class FollowRequest < ApplicationRecord
  belongs_to :be_requested_users, class_name: 'User', :foreign_key => 'request_to'
  belongs_to :requesting_users, class_name: 'User', :foreign_key => 'requested_by'

  validates :request_to,   presence: true
  validates :requested_by, presence: true
end

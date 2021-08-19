class FollowRequest < ApplicationRecord
  belongs_to :relate_to_request_to_user,   class_name: 'User', :foreign_key => 'request_to'
  belongs_to :relate_to_requested_by_user, class_name: 'User', :foreign_key => 'requested_by'

  validates :request_to,   presence: true
  validates :requested_by, presence: true
end

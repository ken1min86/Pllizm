require 'rails_helper'

RSpec.describe FollowRequest, type: :model do
  # it 'is valid with requested_by and request_to both of them relate to user' do
  #   sign_up('John')
  #   user1 = get_current_user_by_response(response)
  #   sign_up('Kim')
  #   user2 = get_current_user_by_response(response)
  #   follow_request = FollowRequest.build(requested_by: user1.id, request_to: user2.id)
  #   expect(follow_request).to be_valid
  # end
  it 'is invalid without requested_by'
  it 'is invalid without request_to'
  it "is invalid when requested_by doesn't relate to user"
  it "is invalid when request_to doesn't relate to user"
end

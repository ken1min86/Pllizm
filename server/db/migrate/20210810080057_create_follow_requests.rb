class CreateFollowRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :follow_requests do |t|
      t.bigint :requested_by, index: true
      t.bigint :request_to, index: true

      t.timestamps

      t.index [:requested_by, :request_to], unique: true
    end
    add_foreign_key :follow_requests, :users, column: :requested_by
    add_foreign_key :follow_requests, :users, column: :request_to
  end
end

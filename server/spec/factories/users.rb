FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "tester#{n}@example.com" }
    sequence(:userid) { |n| "test#{n}" }
    sequence(:username) { |n| "tester#{n}" }
    sequence(:bio) { |n| "私の名前はtester#{n}" }
    password 'password'
    image { Rack::Test::UploadedFile.new(Rails.root.join("db/icons/Account-icon1.png"), "image/png") }
  end
end

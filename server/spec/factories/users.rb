FactoryBot.define do
  factory :user do
    sequence(:userid) { |n| "test#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password 'password'
    username 'tester'
  end
end

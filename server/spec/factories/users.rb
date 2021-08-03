FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "tester#{n}@example.com" }
    sequence(:name) { |n| "tester#{n}" }
    password 'password'
  end
end

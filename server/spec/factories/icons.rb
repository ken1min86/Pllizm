FactoryBot.define do
  factory :icon do
    sequence(:image) { |n|Rack::Test::UploadedFile.new(Rails.root.join("spec/factories/test_icons/Account-icon#{n}.png")) }
  end
end

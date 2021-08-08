FactoryBot.define do
  factory :icon do
    image Rack::Test::UploadedFile.new(Rails.root.join("spec/factories/test_icons/Account-icon1.png"), "image/png")
  end
end

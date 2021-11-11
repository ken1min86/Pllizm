FactoryBot.define do
  factory :post do
    content '今日のご飯はなんだろ'
    icon_id { Icon.all.sample.id }
  end
end

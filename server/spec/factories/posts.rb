FactoryBot.define do
  factory :post do
    content '今日のご飯はなんだろう'
    icon_id { Icon.all.sample.id }
  end
end

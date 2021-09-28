FactoryBot.define do
  factory :hashtag do
    hashname { Faker::Lorem.characters(number:5) }
  end
end
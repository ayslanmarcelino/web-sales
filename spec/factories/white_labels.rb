FactoryBot.define do
  factory :white_label do
    kind_cd { Faker::Lorem.word }
    description { FFaker::Lorem.paragraph }
  end
end

FactoryBot.define do
  factory :comment do
    resource { create(:user) }
    author { create(:user) }
    enterprise { create(:enterprise) }
    description { FFaker::Lorem.sentence }
  end
end

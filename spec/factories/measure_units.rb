FactoryBot.define do
  factory :measure_unit do
    description { Faker::Lorem.word }
    abbreviation { Faker::Address.city_prefix }

    association :enterprise
  end
end

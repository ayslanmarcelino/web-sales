FactoryBot.define do
  factory :person do
    association :address
    association :enterprise

    trait :person do
      name { FFaker::NameBR.name }
      nickname { FFaker::NameBR.first_name }
      document_number { CPF.generate }
      identity_document_type { ['rne', 'rg'].sample }
      identity_document_number { FFaker.numerify('#########') }
      identity_document_issuing_agency { 'SSP' }
      cnh_issuing_state { FFaker::AddressBR.state_abbr }
      cnh_number       { Faker::Number.number(digits: 10) }
      cnh_record       { Faker::Number.number(digits: 11) }
      cnh_type         { 'B' }
      cnh_expires_at   { Time.zone.today + 2.years }
      marital_status { :single }
      birth_date { Date.today - 18.years }
      kind { :person }
    end

    trait :company do
      name { FFaker::Company.name }
      trade_name { FFaker::Company.name }
      document_number { CNPJ.generate }
      kind { :company }
    end
  end
end

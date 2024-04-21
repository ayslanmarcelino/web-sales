# == Schema Information
#
# Table name: people
#
#  id                               :bigint           not null, primary key
#  birth_date                       :date
#  cnh_expires_at                   :date
#  cnh_issuing_state                :string
#  cnh_number                       :string
#  cnh_record                       :string
#  cnh_type                         :string
#  document_number                  :string
#  identity_document_issuing_agency :string
#  identity_document_number         :string
#  identity_document_type           :string
#  kind_cd                          :string
#  marital_status_cd                :string
#  name                             :string
#  nickname                         :string
#  owner_type                       :string
#  trade_name                       :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  address_id                       :bigint
#  enterprise_id                    :bigint
#  owner_id                         :bigint
#
# Indexes
#
#  index_people_on_address_id     (address_id)
#  index_people_on_enterprise_id  (enterprise_id)
#  index_people_on_owner          (owner_type,owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (enterprise_id => enterprises.id)
#
require 'rails_helper'

RSpec.describe Person, type: :model do
  subject { described_class.new(document_number:, name:, owner:, enterprise:, kind:) }

  let!(:document_number) { CPF.generate }
  let!(:name) { Faker::Name.name }
  let!(:owner) { create(:user) }
  let!(:enterprise) { create(:enterprise) }
  let!(:kind) { :person }

  describe 'associations' do
    it { is_expected.to belong_to(:enterprise) }
    it { is_expected.to belong_to(:address).optional }
    it { is_expected.to belong_to(:owner).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:document_number).scoped_to(:owner_type, :enterprise_id).case_insensitive }
    it { is_expected.to validate_presence_of(:document_number) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_one(:user) }
    it { is_expected.to have_many(:contacts) }
  end

  describe 'methods' do
    describe '#format_document_number' do
      context 'when document_number is blank' do
        let!(:document_number) {}

        it 'does not modify document_number' do
          model = build(:enterprise, document_number:)
          expect { model.valid? }.not_to change { model.document_number }
        end
      end

      context 'when document_number is not blank' do
        let!(:document_number) { CPF.generate(true) }
        let!(:stripped_document_number) { CPF.new(document_number).stripped }

        it 'removes non-alphanumeric characters from document_number' do
          model = build(:enterprise, document_number:)
          model.valid?
          expect(model.document_number).to eq(stripped_document_number)
        end

        it 'adds errors to document_number if it is not a valid CPF' do
          model = build(:enterprise, document_number: '12345678000191')
          expect(model.valid?).to eq(false)
          expect(model.errors[:document_number]).to include('não é válido')
        end
      end
    end
  end

  context 'when sucessful' do
    context 'when has person with same document_number' do
      let!(:person) { create(:person, kind, document_number:) }

      context 'when does not have same enterprise' do
        let!(:enterprise) { create(:enterprise) }

        context 'when person' do
          it do
            expect(subject).to be_valid
          end
        end

        context 'when company' do
          let!(:document_number) { CNPJ.generate }
          let!(:kind) { :company }

          it do
            expect(subject).to be_valid
          end
        end
      end

      context 'when does not have same owner' do
        let!(:owner) { create(:address) }

        context 'when person' do
          it do
            expect(subject).to be_valid
          end
        end

        context 'when company' do
          let!(:document_number) { CNPJ.generate }
          let!(:kind) { :company }

          it do
            expect(subject).to be_valid
          end
        end
      end
    end

    context 'when does not have same document_number, same owner and same enterprise' do
      let!(:document_number) { CPF.generate }
      let!(:owner) { create(:address) }
      let!(:enterprise) { create(:enterprise) }
      let!(:kind) { :person }

      it do
        expect(subject).to be_valid
      end
    end
  end

  context 'when unsucessful' do
    context 'when has person with same document_number, enterprise and owner' do
      let!(:person) { create(:person, :person, document_number:, enterprise:, owner:) }

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('CPF/CNPJ já está em uso')
      end
    end

    context 'when do not pass a required attribute' do
      [:document_number, :name].each do |attribute|
        context "when #{attribute}" do
          let!(attribute) {}
          let!(:message) { "#{I18n.t("activerecord.attributes.person.#{attribute}")} não pode ficar em branco" }

          it do
            expect(subject).not_to be_valid
            expect(subject.errors.full_messages.to_sentence).to eq(message)
          end
        end
      end
    end
  end
end

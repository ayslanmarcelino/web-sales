# == Schema Information
#
# Table name: enterprises
#
#  id                               :bigint           not null, primary key
#  active                           :boolean          default(TRUE)
#  birth_date                       :date
#  cell_number                      :string
#  document_number                  :string
#  email                            :string
#  identity_document_issuing_agency :string
#  identity_document_number         :string
#  identity_document_type           :string
#  name                             :string
#  opening_date                     :date
#  representative_document_number   :string
#  representative_name              :string
#  telephone_number                 :string
#  trade_name                       :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  address_id                       :bigint
#  created_by_id                    :bigint
#  white_label_id                   :bigint
#
# Indexes
#
#  index_enterprises_on_address_id      (address_id)
#  index_enterprises_on_created_by_id   (created_by_id)
#  index_enterprises_on_white_label_id  (white_label_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (white_label_id => white_labels.id)
#
require 'rails_helper'

RSpec.describe Enterprise, type: :model do
  subject do
    described_class.new(
      white_label:,
      document_number:,
      email:,
      name:,
      representative_name:,
      representative_document_number:
    )
  end

  let(:white_label) { create(:white_label) }
  let(:document_number) { CNPJ.generate }
  let(:email) { FFaker::Internet.email }
  let(:name) { FFaker::NameBR.name }
  let(:representative_name) { FFaker::NameBR.name }
  let(:representative_document_number) { CPF.generate }

  describe 'associations' do
    it { is_expected.to belong_to(:white_label) }
    it { is_expected.to belong_to(:address).optional }
    it { is_expected.to belong_to(:created_by).class_name('User').optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:document_number) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:representative_name) }
    it { is_expected.to validate_presence_of(:representative_document_number) }
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
        let!(:document_number) { CNPJ.generate(true) }
        let!(:stripped_document_number) { CNPJ.new(document_number).stripped }

        it 'removes non-alphanumeric characters from document_number' do
          model = build(:enterprise, document_number:)
          model.valid?
          expect(model.document_number).to eq(stripped_document_number)
        end

        it 'adds errors to document_number if it is not a valid CNPJ' do
          model = build(:enterprise, document_number: '12345678000191')
          expect(model.valid?).to eq(false)
          expect(model.errors[:document_number]).to include('não é válido')
        end
      end
    end

    describe '#format_representative_document_number' do
      context 'when representative_document_number is blank' do
        let!(:representative_document_number) {}

        it 'does not modify representative_document_number' do
          model = build(:enterprise, representative_document_number: document_number)
          expect { model.valid? }.not_to change { model.representative_document_number }
        end
      end

      context 'when representative_document_number is not blank' do
        let!(:representative_document_number) { CPF.generate(true) }
        let!(:stripped_representative_document_number) { CPF.new(representative_document_number).stripped }

        it 'removes non-alphanumeric characters from representative_document_number' do
          model = build(:enterprise, representative_document_number:)
          model.valid?
          expect(model.representative_document_number).to eq(stripped_representative_document_number)
        end

        it 'adds errors to representative_document_number if it is not a valid CPF' do
          model = build(:enterprise, representative_document_number: '11122233345')
          expect(model.valid?).to eq(false)
          expect(model.errors[:representative_document_number]).to include('não é válido')
        end
      end
    end
  end

  context 'when sucessful' do
    context 'when valid params' do
      it do
        expect(subject).to be_valid
      end
    end
  end

  context 'when unsucessful' do
    context 'when do not pass a required attribute' do
      [:white_label, :email, :document_number, :name, :representative_name, :representative_document_number].each do |attribute|
        context "when #{attribute}" do
          let!(attribute) {}
          let!(:message) { "#{I18n.t("activerecord.attributes.enterprise.#{attribute}")} não pode ficar em branco" }

          it do
            expect(subject).not_to be_valid
            expect(subject.errors.full_messages.to_sentence).to eq(message)
          end
        end
      end
    end

    context 'when has enterprise with existing document_number' do
      let!(:enterprise) { create(:enterprise, document_number:) }

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('CNPJ já está em uso')
      end
    end
  end
end

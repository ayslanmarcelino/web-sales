# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  created_by_id          :bigint
#  current_enterprise_id  :bigint
#  person_id              :bigint
#
# Indexes
#
#  index_users_on_created_by_id          (created_by_id)
#  index_users_on_current_enterprise_id  (current_enterprise_id)
#  index_users_on_email                  (email) UNIQUE
#  index_users_on_person_id              (person_id)
#  index_users_on_reset_password_token   (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (current_enterprise_id => enterprises.id)
#  fk_rails_...  (person_id => people.id)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      person:,
      email:,
      password:
    )
  end

  let!(:person) { create(:person, :person) }
  let!(:email) { FFaker::Internet.email }
  let!(:password) { FFaker::Internet.password }

  describe 'associations' do
    it { is_expected.to belong_to(:person).optional }
    it { is_expected.to belong_to(:current_enterprise).class_name('Enterprise').optional }
    it { is_expected.to belong_to(:created_by).class_name('User').optional }
    it { is_expected.to have_many(:roles) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:created_comments) }
  end

  context 'when sucessful' do
    context 'when valid params' do
      it do
        expect(subject).to be_valid
      end
    end
  end

  context 'when unsuccessful' do
    context 'when do not pass a required attribute' do
      [:email, :password].each do |attribute|
        context "when #{attribute}" do
          let!(attribute) {}
          let!(:message) { "#{I18n.t("activerecord.attributes.user.#{attribute}")} não pode ficar em branco" }

          it do
            expect(subject).not_to be_valid
            expect(subject.errors.full_messages.to_sentence).to eq(message)
          end
        end
      end
    end
  end
end

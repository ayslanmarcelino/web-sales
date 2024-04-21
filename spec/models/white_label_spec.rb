# == Schema Information
#
# Table name: white_labels
#
#  id          :bigint           not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  kind_cd     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe WhiteLabel, type: :model do
  subject do
    described_class.new(
      kind_cd: kind
    )
  end

  let(:kind) { Faker::Lorem.word }

  context 'when sucessful' do
    context 'when valid params' do
      it do
        expect(subject).to be_valid
      end
    end
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:kind_cd) }
  end
end

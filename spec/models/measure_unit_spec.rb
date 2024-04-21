# == Schema Information
#
# Table name: measure_units
#
#  id            :bigint           not null, primary key
#  abbreviation  :string
#  description   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  enterprise_id :bigint
#
# Indexes
#
#  index_measure_units_on_enterprise_id  (enterprise_id)
#
# Foreign Keys
#
#  fk_rails_...  (enterprise_id => enterprises.id)
#
require 'rails_helper'

RSpec.describe MeasureUnit, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:enterprise) }
  end

  describe 'validations' do
    describe '#presence' do
      [:description, :abbreviation].each do |attribute|
        it { is_expected.to validate_presence_of(attribute) }
      end
    end

    describe '#uniqueness' do
      [:description, :abbreviation].each do |attribute|
        it { is_expected.to validate_uniqueness_of(attribute).scoped_to(:enterprise_id) }
      end
    end
  end
end

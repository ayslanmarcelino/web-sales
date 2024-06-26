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
class MeasureUnit < ApplicationRecord
  belongs_to :enterprise

  validates :description, :abbreviation, presence: true
  validates :description, :abbreviation, uniqueness: { scope: :enterprise_id }
end

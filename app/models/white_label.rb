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
class WhiteLabel < ApplicationRecord
  KINDS = [:default].freeze

  has_many :enterprises

  validates :kind_cd, uniqueness: true

  as_enum :kind, KINDS, prefix: true, map: :string

  scope :active,
        -> {
          where(active: true)
        }

  scope :disabled,
        -> {
          where(active: false)
        }
end

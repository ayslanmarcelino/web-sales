# == Schema Information
#
# Table name: contacts
#
#  id               :bigint           not null, primary key
#  cell_number      :string
#  email            :string
#  observation      :string
#  telephone_number :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  person_id        :bigint
#
# Indexes
#
#  index_contacts_on_person_id  (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#
class Contact < ApplicationRecord
  belongs_to :person

  def self.permitted_params
    [
      :id,
      :cell_number,
      :observation,
      :email,
      :telephone_number,
      :_destroy
    ]
  end
end

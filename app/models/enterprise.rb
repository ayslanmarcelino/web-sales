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
class Enterprise < ApplicationRecord
  IDENTITY_DOCUMENT_TYPES = [
    ['RG', :rg],
    ['RNE', :rne]
  ].freeze

  belongs_to :white_label
  belongs_to :address, optional: true, dependent: :destroy
  belongs_to :created_by, class_name: 'User', optional: true

  validates :document_number, uniqueness: true, if: -> { document_number.present? }
  validates :email,
            :document_number,
            :name,
            :representative_name,
            :representative_document_number,
            presence: true

  accepts_nested_attributes_for :address

  before_validation :format_document_number
  before_validation :format_representative_document_number

  def self.permitted_params
    [
      :email,
      :document_number,
      :name,
      :trade_name,
      :opening_date,
      :representative_name,
      :representative_document_number,
      :cell_number,
      :telephone_number,
      :identity_document_type,
      :identity_document_number,
      :identity_document_issuing_agency,
      :birth_date,
      :address_id,
      :white_label_id
    ]
  end

  def formatted_name
    "#{name} | #{CNPJ.new(document_number).formatted}"
  end

  def format_document_number
    return if document_number.blank?

    self.document_number = document_number.gsub!(/[^0-9a-zA-Z]/, '') unless document_number.match?(/\A\d+\z/)
    errors.add(:document_number, 'não é válido') unless CNPJ.valid?(document_number)
  end

  def format_representative_document_number
    return if representative_document_number.blank?

    unless representative_document_number.match?(/\A\d+\z/)
      self.representative_document_number = representative_document_number.gsub!(
        /[^0-9a-zA-Z]/,
        ''
      )
    end
    errors.add(:representative_document_number, 'não é válido') unless CPF.valid?(representative_document_number)
  end
end

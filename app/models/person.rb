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
class Person < ApplicationRecord
  IDENTITY_DOCUMENT_TYPES = [
    ['RG', :rg],
    ['RNE', :rne]
  ].freeze

  MARITAL_STATUSES = [
    [I18n.t('activerecord.attributes.person.marital_status_list.single'), :single],
    [I18n.t('activerecord.attributes.person.marital_status_list.married'), :married],
    [I18n.t('activerecord.attributes.person.marital_status_list.divorced'), :divorced],
    [I18n.t('activerecord.attributes.person.marital_status_list.widowed'), :widowed]
  ].freeze

  KINDS = [
    [I18n.t('activerecord.attributes.person.kind_list.company'), :company],
    [I18n.t('activerecord.attributes.person.kind_list.person'), :person]
  ].freeze

  CNH_TYPES = [
    :a,
    :b,
    :ab,
    :c,
    :d,
    :e
  ].freeze

  as_enum :marital_status, [:single, :married, :divorced, :widowed], prefix: true, map: :string
  as_enum :kind, [:company, :person], prefix: true, map: :string

  belongs_to :enterprise
  belongs_to :address, optional: true, dependent: :destroy
  belongs_to :owner, polymorphic: true, optional: true

  has_one :user
  has_many :contacts, inverse_of: :person

  validates :document_number, uniqueness: { scope: [:owner_type, :enterprise_id] }, if: -> { document_number.present? }
  validates :document_number, :name, presence: true

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :contacts, reject_if: :all_blank, allow_destroy: true

  before_validation :format_document_number

  def self.permitted_params
    [
      :id,
      :birth_date,
      :cell_number,
      :document_number,
      :identity_document_issuing_agency,
      :identity_document_number,
      :identity_document_type,
      :cnh_expires_at,
      :cnh_issuing_state,
      :cnh_number,
      :cnh_record,
      :cnh_type,
      :marital_status_cd,
      :name,
      :nickname,
      :telephone_number,
      :kind_cd,
      :enterprise_id,
      :owner_id,
      :owner_type
    ]
  end

  def translated_kind
    I18n.t("activerecord.attributes.person.kind_list.#{kind}")
  end

  def format_document_number
    return if document_number.blank?

    self.document_number = document_number.gsub!(/[^0-9a-zA-Z]/, '') unless document_number.match?(/\A\d+\z/)

    if kind_person?
      errors.add(:document_number, 'não é válido') unless CPF.valid?(document_number)
    elsif kind_company?
      errors.add(:document_number, 'não é válido') unless CNPJ.valid?(document_number)
    end
  end
end

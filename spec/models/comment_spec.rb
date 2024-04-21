# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  author_type   :string
#  description   :text
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  author_id     :bigint
#  enterprise_id :bigint
#  resource_id   :bigint
#
# Indexes
#
#  index_comments_on_author         (author_type,author_id)
#  index_comments_on_enterprise_id  (enterprise_id)
#  index_comments_on_resource       (resource_type,resource_id)
#
# Foreign Keys
#
#  fk_rails_...  (enterprise_id => enterprises.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:resource) }
    it { is_expected.to belong_to(:enterprise) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
  end
end

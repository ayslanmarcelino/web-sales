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
class Comment < ApplicationRecord
  belongs_to :author, polymorphic: true
  belongs_to :resource, polymorphic: true
  belongs_to :enterprise

  validates :description, presence: true
end

require 'rails_helper'

RSpec.describe Comments::Create do
  subject { described_class.new(resource:, author:, description:, enterprise:) }

  let!(:resource) { create(:user) }
  let!(:author) { create(:user) }
  let!(:description) { FFaker::Lorem.sentence }
  let!(:enterprise) { create(:enterprise) }

  describe '#call' do
    context 'when creates a comment' do
      it do
        expect do
          subject.call

          comment = Comment.last

          expect(comment.resource).to eq(resource)
          expect(comment.author).to eq(author)
          expect(comment.description).to eq(description)
          expect(comment.enterprise).to eq(enterprise)
        end.to change { Comment.count }.by(1)
          .and change { resource.comments.count }.by(1)
          .and change { author.created_comments.count }.by(1)
      end
    end
  end
end

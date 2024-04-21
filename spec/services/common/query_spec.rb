# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Common::Query do
  subject { described_class.new(klass:, params:, accessible_by:) }

  let(:klass) { User }
  let(:params) { { email_cont: '200' } }
  let(:user) { create(:user) }
  let(:accessible_by) { Ability.new(user) }
  let(:ransack_class) { Common::Index }

  describe '#call' do
    before { allow(klass).to receive(:ransack).with(params).and_return(ransack_class) }

    it 'calls the query method on the class with the provided params' do
      expect(subject.call).to eq(ransack_class)
    end
  end
end

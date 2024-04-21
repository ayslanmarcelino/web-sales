# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Common::Index do
  subject { described_class.new(klass:, params:, accessible_by:) }

  let(:klass) { User }
  let(:params) { ActionController::Parameters.new(active_eq: false) }
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, current_enterprise: enterprise) }
  let!(:user_role) { create(:user_role, enterprise:, user:) }
  let(:accessible_by) { Ability.new(user) }

  let!(:other_user) { create(:user, current_enterprise: enterprise, active: false) }
  let!(:another_user) { create(:user, current_enterprise: enterprise, active: false) }

  describe '#call' do
    it 'returns correct response' do
      result = subject.call

      expect(result.first.class).to eq(Ransack::Search)
      expect(result.second).to match_array([other_user, another_user])
    end
  end
end

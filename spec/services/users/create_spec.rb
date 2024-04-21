require 'rails_helper'

RSpec.describe Users::Create, type: :service do
  describe '#call' do
    subject { described_class.new(params:, person:, enterprise:) }

    let!(:params) { { email: FFaker::Internet.email } }
    let!(:person) { create(:person, :person) }
    let!(:user) { create(:user, person:) }
    let!(:enterprise) { create(:enterprise, created_by: user) }

    context 'when user is found' do
      let!(:user_found) { create(:user, person:) }

      before { allow(Users::Find).to receive(:call).with(email: params[:email]).and_return(user_found) }

      it 'returns the found user' do
        expect(subject.call).to eq(user_found)
      end

      it 'does not create a new user' do
        expect { subject.call }.not_to change { User.count }
      end

      it 'does not update the person' do
        expect { subject.call }.not_to change { person }
      end

      it 'does not send an email' do
        expect(UserMailer).not_to receive(:with)
        subject.call
      end
    end

    context 'when user is not found' do
      it 'creates a new user' do
        expect { subject.call }.to change { User.count }.by(1)
      end

      it 'sets the user attributes' do
        created_user = subject.call

        expect(created_user.email).to eq(params[:email])
        expect(created_user.person).to eq(person)
        expect(created_user.current_enterprise).to eq(enterprise)
        expect(created_user.created_by).to eq(user)
      end

      it 'updates the person' do
        expect { subject.call }.to change { person.reload.owner }.from(nil).to(an_instance_of(User))
        expect(person.reload.kind).to eq(:person)
      end

      it 'sends an e-mail' do
        expect(UserMailer).to receive(:with).and_call_original
        subject.call
      end
    end
  end
end

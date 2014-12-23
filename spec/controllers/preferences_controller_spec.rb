require 'spec_helper'

describe PreferencesController do
  let(:user) { FactoryGirl.create(:user) }
  let(:preferences) { user.preferences }

  before(:each) { before_request rescue nil }

  describe "#edit" do
    before(:each) {
      get 'edit', user_id: user.id
    }

    context 'when user authenticated' do
      let(:before_request) { controller.auto_login(user) }

      it { expect(response).to be_success }
    end

    context 'when user not authenticated' do
      let(:before_request) { controller.logout }

      it { expect(response).to redirect_to(root_url) }
    end
  end

  describe "#update" do
    before(:each) do
      put 'update', user_id: user.id, preferences: {
        audio_volume: 50,
        email_notification: true
      }
    end
    context 'when user authenticated' do
      let(:before_request) { controller.auto_login(user) }

      it { response.should redirect_to([:edit, user, :preferences]) }
    end

    context 'when user not authenticated' do
      let(:before_request) { controller.logout }

      it { expect(response).to redirect_to(root_url) }
    end
  end

end

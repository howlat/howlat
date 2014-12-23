require 'spec_helper'

describe HomeController do
  let(:user) { FactoryGirl.create(:user) }
  before(:each) { before_request rescue nil }

  describe "#index" do
    before(:each) { get :index }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to redirect_to(controller.after_sign_in_url) }
      end

      context 'when user not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to be_success }
        it { expect(response).to render_template(:index) }

      end
  end

end

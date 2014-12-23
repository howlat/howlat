require 'spec_helper'

describe IdentitiesController do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) { before_request rescue nil }

  describe "#destroy" do
    before(:each) {
      @identity = FactoryGirl.create(:identity, user_id: user.id)
      before_request rescue nil
      delete :destroy, id: @identity.id, user_id: user.id
    }
    context 'when user authenticated' do
      let(:before_request) { controller.auto_login(user) }

      it("should destroy identity") {
        expect(Identity.exists?(@identity.id)).to be_false
      }
      it { expect(response).to redirect_to([:edit, user]) }
    end

    context 'when user not authenticated' do
      let(:before_request) { controller.logout }

      it { expect(response).to redirect_to(root_url) }
    end
  end

end

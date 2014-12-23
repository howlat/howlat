require 'spec_helper'

describe ApplicationController do

  context "when AccessDenied Error occurs" do
    controller do
      def index
        raise CanCan::AccessDenied
      end
    end

    before(:each) { before_request rescue nil }
    before(:each) { get :index }

    it("should set flash error message") {
      expect(flash[:alert]).to be_present
    }
    it { expect(response).to redirect_to(root_url) }
  end

end

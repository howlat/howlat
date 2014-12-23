require 'spec_helper'

describe SessionsController do
  xit 'not used in current version' do
    before(:each) { before_request rescue nil }

    let(:current_password) { SecureRandom.hex(8) }
    let(:user) {
      FactoryGirl.create(:user, password: current_password)
    }

    describe "#new" do
      before(:each) { get :new }

      it { expect(response).to render_template :new }
      it { expect(response).to be_success }
    end

    describe "#create" do
      before(:each) { post :create, session: session_params }

      context "with valid session params" do

        let(:session_params) {
          {
            email: user.email,
            password: current_password
          }
        }

        it ("should assign user object based on credentials") {
          expect(assigns[:user]).to be_kind_of(User)
          expect(assigns[:user].id).to eql(user.id)
        }
        it ("should login user") {
          expect(controller.current_user).to be_present
          expect(controller.current_user.id).to eql(user.id)
        }
        it ("should clear email data in session") {
          expect(session[:email]).to be_blank
        }
        it ("should assign flash notice message") {
          expect(flash[:notice]).to be_present
        }
        it { expect(response).to redirect_to (controller.after_sign_in_url) }

      end

      context "with invalid session params" do

        let(:session_params) {
          {
            email: user.email,
            password: ''
          }
        }

        it ("should assign blank user object") {
          expect(assigns[:user]).to be_blank
        }
        it ("should not login user") {
          expect(controller.current_user).to be_blank
        }
        it ("should not clear email data in session") {
          expect(session[:email]).to be_blank
        }
        it ("should assign flash alert message") {
          expect(flash.now[:alert]).to be_present
        }
        it { expect(response).to render_template :new }

      end
    end

    describe '#destroy' do
      let(:before_request) { controller.auto_login(user) }
      before(:each) { delete :destroy }

      it ("should logout user") {
        expect(controller.current_user).to be_blank
      }
      it ("should assign flash notice message") {
        expect(flash[:notice]).to be_present
      }
      it { expect(response).to redirect_to root_url }
    end
  end
end

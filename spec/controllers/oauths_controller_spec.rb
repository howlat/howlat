require 'spec_helper'

describe OauthsController do
  before(:each) { before_request rescue nil }
  let(:user) { FactoryGirl.create(:user) }

  describe "#callback" do
    let(:auth_hash) { FactoryGirl.build(:valid_oauth) }
    before(:each) {
      subject.env['omniauth.auth'] = auth_hash
      session['oauth.context'] = context
      post :callback, provider: auth_hash[:provider]
    }

    context "when in signin context" do
      let(:before_request) { subject.logout }
      let(:context) { 'signin' }
      it("should clear context after finished") {
        expect(session['oauth.context']).to be_nil
      }
    end

    context "when in signup context" do
      let(:before_request) { subject.logout }
      let(:context) { 'signup' }
      it("should clear context after finished") {
        expect(session['oauth.context']).to be_nil
      }
    end

    context "when in connect context" do
      let(:context) { 'connect' }
      let(:before_request) { subject.auto_login(user) }

      context "when user is authenticated" do

        it("should clear context after finished") {
          expect(session['oauth.context']).to be_nil
        }

        it { expect(response).to redirect_to([:edit, user]) }

      end

      context 'when user is not authenticated' do
        let(:before_request) { subject.logout }

        it { expect(response).to redirect_to(root_url) }
      end

    end

     context "when in bad context" do
      let(:before_request) { subject.logout }
      let(:context) { 'unknown-context' }

      it("should set falsh alert message") {
        expect(flash[:alert]).to be_present
      }
      it { expect(response).to redirect_to(root_url) }
    end

  end

  describe "#signup" do

    context "when OAuth" do

      before(:each) {
        subject.env['omniauth.auth'] = auth_hash
        session['oauth.context'] = 'signup'
        post :callback, provider: auth_hash[:provider]
      }

      context "when data is valid" do
        let(:auth_hash) { FactoryGirl.build(:valid_oauth) }
        it("should register user") {
          expect(!!User.where(email: auth_hash[:info][:email]).exists?).to be_true
        }
        it("should sign in user") {
          expect(subject.current_user).to be_present
        }
        it { expect(response).to redirect_to(subject.after_sign_in_url) }
      end

      context "when user with provided email exists" do
        let(:auth_hash) { FactoryGirl.build(:valid_oauth) }
        let(:existing_user) { FactoryGirl.create(:user, email: auth_hash[:info][:email]) }
        let(:before_request) { existing_user }

        it("should set email value in session") {
          expect(session[:email]).to be_eql(existing_user.email)
        }
        it("should set flash message") { expect(flash[:notice]).to be_present }
        it { expect(response).to redirect_to(root_url) }
      end

      context "when user data invalid or email empty" do
        let(:auth_hash) { FactoryGirl.build(:valid_oauth_without_email) }
        it("should assign user") { expect(assigns[:user]).to be_present }
        it { expect(response).to render_template(:signup) }
      end
    end

    context "when form" do

      before(:each) {
        pending('we are only supporting github signup process right now')
        subject.env['omniauth.auth'] = FactoryGirl.build(:valid_oauth_without_email)
        session['oauth.context'] = 'signup'
        subject.send :store_auth_params
        subject.env['omniauth.auth'] = nil
        post :signup, provider: auth_hash[:provider], user: auth_hash[:info]
      }

      context "when data is valid" do
        let(:auth_hash) { FactoryGirl.build(:valid_oauth) }
        it("should register user") {
          expect(!!User.where(email: auth_hash[:info][:email]).exists?).to be_true
        }
        it("should sign in user") {
          expect(subject.current_user).to be_present
        }
        it { expect(response).to redirect_to(subject.after_sign_in_url) }
      end

      context "when user with provided email exists" do
        let(:auth_hash) { FactoryGirl.build(:valid_oauth) }
        let(:existing_user) { FactoryGirl.create(:user, email: auth_hash[:info][:email]) }
        let(:before_request) { existing_user }

        it("should set email value in session") {
          expect(session[:email]).to be_eql(existing_user.email)
        }
        it("should set flash message") { expect(flash[:notice]).to be_present }
        it { expect(response).to redirect_to(root_url) }
      end

      context "when user data invalid or email empty" do
        let(:auth_hash) { FactoryGirl.build(:valid_oauth_without_email) }
        it("should assign user") { expect(assigns[:user]).to be_present }
        it { expect(response).to render_template(:signup) }
      end
    end

  end

  describe "#signin" do
    before(:each) {
      subject.env['omniauth.auth'] = auth_hash
      session['oauth.context'] = 'signin'
      post :callback, provider: auth_hash[:provider]
    }
    context "when authentication was successfull" do
      let(:auth_hash) { FactoryGirl.build(:valid_oauth) }
      let(:before_request) {
        user.identities.create(auth_hash.slice(:uid, :provider))
      }

      it("should sign in user") {
        expect(subject.current_user).to be_present
      }
      it { expect(response).to redirect_to(subject.after_sign_in_url) }
    end
  end

  describe "#failure" do
    let!(:message) { "Some oauth error" }
    before(:each) { get :failure, message: message }

    it { expect(response).to be_success }
    it("should set flash message") {
      expect(flash.now[:alert]).to eql(message)
    }
    it { expect(response).to render_template :failure }
  end
end

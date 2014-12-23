require 'spec_helper'

describe PasswordResetsController do
  before(:each) { before_request rescue nil }

  let(:current_password) { '12345678' }
  let(:user) { FactoryGirl.create(:user, password: current_password) }
  let!(:old_crypted_password) { user.crypted_password }

  describe "#new" do
    before(:each) { get :new }

    it ("should assign new user object") {
      expect(assigns(:user)).to be_kind_of(User)
      expect(assigns(:user)).not_to be_persisted
    }
    it { expect(response).to render_template :new }
    it { expect(response).to be_success }

  end

  describe "#create" do
    before(:each) { post :create, user: { email: email } }
    context "when user with provided email address exists" do
      let(:email) { user.email }

      it ("should assign founded user object") {
        assigns(:user).should be_kind_of(User)
        assigns(:user).should be_persisted
      }
      it ("should logout current user") {
        expect(controller.current_user).to be_blank
      }
      it { expect(response).to render_template :create }
      it { expect(response).to be_success }
    end
    context "when user with provided email address does not exist" do
      let(:email) { "does-not-exist" }

      it ("should assign blank user object") {
        assigns(:user).should be_blank
      }
      it { expect(response).to render_template :create }
      it { expect(response).to be_success }
    end
  end

  describe "#edit" do
    let(:before_request) { user.deliver_reset_password_instructions! }
    before(:each) { get :edit, id: reset_password_token }

    context "when reset password token exists" do
      let(:reset_password_token) { user.reset_password_token }

      it ("should assign reset password token") {
        expect(assigns[:token]).to eql(reset_password_token)
      }
      it ("should assign user object from token") {
        expect(assigns[:user]).to be_eql(user)
      }
      it ("should assign form object") {
        expect(assigns[:form]).to be_present
      }
      it { expect(response).to render_template :edit }
      it { expect(response).to be_success }
    end

    context "when reset password token does not exist" do
      let(:reset_password_token) { 'does-not-exist' }

      it ("should assign reset password token") {
        expect(assigns[:token]).to eql(reset_password_token)
      }
      it ("should not assign user object") {
        expect(assigns[:user]).to be_blank
      }
      it ("should not assign form object") {
        expect(assigns[:form]).to be_blank
      }
      it { expect(response).to redirect_to(root_url)}
    end

    context "when reset password token has expired" do
      let(:before_request) {
        super()
        user.reset_password_token_expires_at = user.reset_password_token_expires_at - 1.year
        user.save
      }

      let(:reset_password_token) { user.reset_password_token }

      it ("should assign reset password token") {
        expect(assigns[:token]).to eql(reset_password_token)
      }
      it ("should not assign user object") {
        expect(assigns[:user]).to be_blank
      }
      it ("should not assign form object") {
        expect(assigns[:form]).to be_blank
      }
      it { expect(response).to redirect_to(root_url)}
    end
  end

  describe "#update" do
    let(:before_request) { user.deliver_reset_password_instructions! }
    let(:new_password) { current_password.to_s << SecureRandom.hex(6).to_s }
    before(:each) {
      put :update,
        id: reset_password_token,
        password: {
          new_password: new_password,
          new_password_confirmation: new_password
        }
    }

    context "when reset password token exists" do
      let(:reset_password_token) { user.reset_password_token }

      context "when valid password and confirmation" do
        it ("should change user password") {
          expect(assigns[:user].reload.crypted_password).not_to eql(old_crypted_password)
        }

        it { expect(response).to render_template :update }
        it { expect(response).to be_success }
      end

      context "when invalid password or confirmation" do
        let(:new_password) { SecureRandom.hex.chars.first(2).join }

        it ("should not change user password") {
          expect(assigns[:user].reload.crypted_password).to eql(old_crypted_password)
        }
        it { expect(response).to render_template :edit }
        it { expect(response).to be_success }
      end

      it ("should assign reset password token") {
        expect(assigns[:token]).to eql(reset_password_token)
      }
      it ("should assign user object from token") {
        expect(assigns[:user]).to be_eql(user)
      }
      it ("should assign form object") {
        expect(assigns[:form]).to be_present
      }

    end
    context "when reset password token does not exist" do
      let(:reset_password_token) { 'does-not-exist' }

      it ("should assign reset password token") {
        expect(assigns[:token]).to eql(reset_password_token)
      }
      it ("should not assign user object") {
        expect(assigns[:user]).to be_blank
      }
      it ("should not assign form object") {
        expect(assigns[:form]).to be_blank
      }
      it { expect(response).to redirect_to(root_url)}
    end

    context "when reset password token has expired" do
      let(:before_request) {
        super()
        user.reset_password_token_expires_at = user.reset_password_token_expires_at - 1.year
        user.save
      }

      let(:reset_password_token) { user.reset_password_token }

      it ("should assign reset password token") {
        expect(assigns[:token]).to eql(reset_password_token)
      }
      it ("should not assign user object") {
        expect(assigns[:user]).to be_blank
      }
      it ("should not assign form object") {
        expect(assigns[:form]).to be_blank
      }
      it { expect(response).to redirect_to(root_url)}
    end
  end

end

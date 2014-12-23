require 'spec_helper'

describe PasswordsController do
  let(:current_password) { '12345678' }
  let(:user) { FactoryGirl.create(:user, password: current_password) }
  before(:each) { before_request rescue nil }

  describe "#update" do

    let!(:old_crypted_password) { user.crypted_password }
    let(:new_password) { FactoryGirl.attributes_for(:user).fetch(:password, "187654321") }
    let(:password_atrributes) {
      {
        current_password: current_password,
        new_password: new_password,
        new_password_confirmation: new_password,
      }
    }

    before(:each) { patch :update, user_id: user.id, password: password_atrributes }

    context 'when user authenticated' do
      let(:before_request) { controller.auto_login(user) }

      it("should assign form object") { expect(assigns(:password_change_form)).to be_present }

      it("should assign user as currently logged in user") {
        expect(assigns(:user)).to eq(controller.current_user)
      }

      context 'with valid password and confirmation' do
        it("should update user password") {
          expect(assigns(:user).reload.crypted_password).to_not eql(old_crypted_password)
        }

        it { expect(response).to be_success }
        it { expect(response).to render_template 'users/edit' }
      end

      context 'with invalid password' do
        let(:password_atrributes) { super().merge!(current_password: '') }

        it("should not update user's password") {
          expect(assigns(:user).crypted_password).to eql(old_crypted_password)
        }

        it { expect(response).to be_success }
        it { expect(response).to render_template 'users/edit' }
      end

    end

    context 'when user not authenticated' do
      let(:before_request) { controller.logout }

      it { expect(response).to redirect_to(root_url) }
    end

  end
end

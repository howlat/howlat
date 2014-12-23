require 'spec_helper'

describe UsersController do
  let(:current_password) { '12345678' }
  let(:user) { FactoryGirl.create(:user, password: current_password) }
  before(:each) { before_request rescue nil }

  describe "#show" do

    before(:each) { get :show, id: user.id }

    context 'when user authenticated' do
      let(:before_request) { controller.auto_login(user) }

      it("should assign user as currently logged in user") {
        expect(assigns(:user)).to eq(controller.current_user)
      }
      it { expect(response).to render_template :show }
      it { expect(response).to be_success }
    end

    context 'when user not authenticated' do
      let(:before_request) { controller.logout }

      it { expect(response).to redirect_to(root_url) }
    end

  end

  describe "#edit" do
    before(:each) { get :edit, id: user.id }

    context 'when user authenticated' do
      let(:before_request) { controller.auto_login(user) }

      it("should assign user as currently logged in user") {
        expect(assigns(:user)).to eq(controller.current_user)
      }
      it { expect(response).to render_template :edit }
      it { expect(response).to be_success }

    end

    context 'when user not authenticated' do
      let(:before_request) { controller.logout }

      it { expect(response).to redirect_to(root_url) }
    end
  end

  describe "#update" do
    let(:new_atrributes) { FactoryGirl.attributes_for(:user) }
    before(:each) {
      patch :update, user: new_atrributes, id: user.id
    }

    context 'when user authenticated' do
      let(:before_request) { controller.auto_login(user) }

      let!(:old_updated_at) { user.updated_at }

      it("should assign user") { expect(assigns(:user)).to be_present }
      it("should assign user as currently logged in user") {
        expect(assigns(:user)).to eq(controller.current_user)
      }

      context 'with valid request parameters' do
        it("should update user") {
          new_atrributes.reject{ |k,v| k == :password }.each do |attr, value|
            expect(assigns(:user).reload.send(attr.to_s.to_sym)).to eql(value)
          end
        }
        it { expect(response).to redirect_to([:edit, user]) }
      end

      context 'with invalid request parameters' do
        let(:new_atrributes) { FactoryGirl.attributes_for(:user).merge!(email: '1234') }

        it("should not update user") {
          expect(user.changed?).to be_true
        }

        it { expect(response).to be_success }
        it { expect(response).to render_template :edit }
      end

    end

    context 'when user not authenticated' do
      let(:before_request) { controller.logout }

      it { expect(response).to redirect_to(root_url) }
    end

  end

  describe "#destroy" do
    before(:each) { delete :destroy, id: user.id }

    context 'when user authenticated' do
      let(:before_request) {
        controller.auto_login(user)
      }

      it("should logout user") { controller.current_user.should be_false }
      it("should destroy user") {
        expect(User.exists?(user.id)).to be_false
      }
      it { expect(response).to redirect_to(root_url) }

    end

    context 'when user not authenticated' do
      let(:before_request) { controller.logout }
      it("should not destroy user") { expect(user).to_not be_destroyed }

      it { expect(response).to redirect_to(root_url) }
    end

  end

end

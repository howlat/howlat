require 'spec_helper'

describe InvitationsController do
  xit 'not used in current version' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:invited_user) { FactoryGirl.create(:user) }
    let!(:organization) { FactoryGirl.create(:organization) }
    let!(:room) {
      r = FactoryGirl.create(:room, owner_id: organization.id)
      r.users << user
      r
    }

    let(:invitation) {
      FactoryGirl.create(:invitation, room_id: room.id, email: invited_user.email)
    }
    let(:invitation_params) {
      { email: invited_user.email }
    }
    let(:format) { :js }

    before(:each) { before_request rescue nil }

    describe "#new" do

      before(:each) {
        get :new, {
          organization_id: organization.id,
          room_id: room.id,
          format: format
        }
      }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }
        let(:resource) { assigns('invitation') }

        it("should assign new invitation object") {
          expect(resource).not_to be_persisted
          expect(resource).to be_kind_of(Invitation)
        }
        it("should assign emails variable") {
          expect(assigns(:emails)).to be_kind_of(Array)
        }

        it { expect(response).to render_template(:new) }
      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end

    end

    describe "#create" do

      before(:each) {
        post :create, {
          organization_id: organization.id,
          room_id: room.id,
          invitation: invitation_params,
          format: format
        }
      }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        subject(:resource) { assigns('invitation') }

        context "when valid email" do

          it("should assign invitation object") {
            expect(resource).to be_present
          }
          it("should create valid invitation") {
            expect(resource).to be_valid
            expect(resource).to be_persisted
          }

          it { expect(response).to render_template(:create) }
        end

        context "when invalid email" do
          let(:invitation_params) {
            { email: 'this-is-not-an-email' }
          }

          it("should assign invitation object") {
            expect(resource).to be_present
          }

          it("should not create invitation") {
            expect(resource).not_to be_persisted
          }

          it { expect(response).to render_template(:error) }

        end

        context "when email already has access to room" do
          let(:invitation_params) {
            { email: user.email }
          }

          it("should assign invitation object") {
            expect(resource).to be_present
          }

          it("should not create invitation") {
            expect(resource).not_to be_persisted
          }

          it { expect(response).to render_template(:error) }

        end

      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end

    describe "#accept" do

      before(:each) {
        get :accept, {
          organization_id: organization.id,
          room_id: room.id,
          token: invitation.token,
          format: format
        }
      }

      it("should set cookie with invitation token") {
        expect(cookies[:invitation]).to eql(assigns[:invitation].token)
      }

      it("should assign invitation object") {
        expect(assigns[:invitation]).to be_present
        expect(assigns[:invitation]).to eql(invitation)
      }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(invited_user) }

        context "when invitation acceptance was successfull" do
          it {
            expect(response).to redirect_to(chat_organization_room_path(invitation.room.organization.slug, invitation.room.slug))
          }
        end

        it("should clear cookie with invitation token") {
          expect(cookies[:invitation]).to be_blank
        }
      end

      context 'when user not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }

      end
    end

    describe "#destroy" do
      before(:each) {
        delete :destroy, {
          organization_id: organization.id,
          room_id: room.id,
          id: invitation.id,
          format: format
        }
      }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        context "when HTML format" do
          let(:format) { (super().to_s.clear << 'html').to_sym }

          it { expect(response).to redirect_to(organization) }
        end

        context "when JS format" do
          it { expect(response).to render_template(:destroy) }
        end

        let(:resource) { assigns('invitation') }

        it("should assign invitation object") { expect(resource).to be }
        it("should destroy invitation") { expect(resource).to be_destroyed }

      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end

    describe "#resend" do
      before(:each) {
        post :resend, {
          organization_id: organization.id,
          room_id: room.id,
          id: invitation.id,
          format: :js
        }
      }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        context "when JS format" do
          it { expect(response).to render_template(:resend) }
        end

        let(:resource) { assigns('invitation') }

        it("should assign invitation object") { expect(resource).to be }
        it { expect(response).to be_success }

      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end
  end
end

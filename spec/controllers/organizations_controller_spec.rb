require 'spec_helper'

describe 'OrganizationsController' do
  xit 'not used in current version' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:organization) { FactoryGirl.create(:organization) }
    let!(:member) {
      FactoryGirl.create(:member, {
        organization_id: organization.id,
        user_id: user.id,
        role_id: Role.owner.id
      })
    }

    before(:each) { before_request rescue nil }

    describe "#index" do
      before(:each) { get :index }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to be_success }
        it { expect(response).to render_template(:index) }

        subject(:collection) { assigns('organizations') }

        it ("should assign organizations list") { expect(collection).to be }
        it ("should include organization in the list"){
          expect(collection).to include(organization)
        }

      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }
        it { expect(response).to redirect_to(root_url) }
      end

    end



    describe "#show" do
      before(:each) { get :show, id: organization.id }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to be_success }
        it { expect(response).to render_template(:show)}

        subject(:resource) { assigns('organization') }

        it ("should assign requested organization object") {
          expect(resource).to eq(organization)
        }
      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end

    end

    describe "#new" do
      before(:each) { get :new }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to be_success }
        it { expect(response).to render_template(:new)}

        subject(:resource) { assigns('organization') }

        it("should assign new organization object") {
          expect(resource).to be_new_record
        }
      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end

    end

    describe "#edit" do
      before(:each) { get :edit, id: organization.id }
      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to be_success }
        it { expect(response).to render_template(:edit)}

        subject(:resource) { assigns('organization') }

        it("should assign requested organization object") {
          expect(resource).to eq(organization)
        }
      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end

    describe "#create" do
      let(:organization_name) {
        FactoryGirl.attributes_for(:organization).fetch(:name, "Create Test")
      }

      before(:each) {
        post :create, id: organization.id, organization: { name: organization_name }
      }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        context "when valid organization name provided" do
          it { expect(response).to redirect_to(action: :index) }

          subject(:resource) { assigns('organization') }

          it("should assign organization object") { expect(resource).to be_kind_of(Organization) }
          it("should create organization object") {
            expect(resource).to be_persisted
            expect(resource.name).to eq(organization_name)
          }
        end

        context "when invalid organization name provided" do
          let(:organization_name) { super().clear }

          it { expect(response).to render_template(:new) }

          subject(:resource) { assigns('organization') }

          it("should assign organization object") { expect(resource).to be_kind_of(Organization) }
          it("should not create organization object") {
            expect(resource).not_to be_persisted
          }
        end

        context "when organization name provided already exists" do
          let(:before_request) {
            super()
            FactoryGirl.create(:organization, name: organization_name)
          }

          it { expect(response).to render_template(:new) }

          subject(:resource) { assigns('organization') }

          it("should assign organization object") {
            expect(resource).to be_kind_of(Organization)
          }
          it("should not create organization object") {
            expect(resource).not_to be_persisted
          }
        end
      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end

    describe "#update" do
      let(:organization_name) {
        FactoryGirl.attributes_for(:organization).fetch(:name, "Update Test")
      }

      before(:each) {
        put :update, id: organization.id, organization: { name: organization_name }
      }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        context "when valid organization name provided" do
          it { expect(response).to redirect_to(action: :index) }

          subject(:resource) { assigns('organization') }

          it("should assign requested organization object") {
            expect(resource).to eql(organization)
          }
          it("should update organization object") {
             expect(resource.reload.name).to eq(organization_name)
          }
        end

        context "when invalid organization name provided" do
          let(:organization_name) { super().clear }

          it { expect(response).to render_template(:edit) }

          subject(:resource) { assigns('organization') }

          it("should assign requested organization object") {
            expect(resource.id).to eql(organization.id)
          }
          it("should not update organization object") {
            expect(resource.reload.name).to_not eql(organization_name)
          }
        end

        context "when organization name provided already exists" do
          let(:before_request) {
            super()
            FactoryGirl.create(:organization, name: organization_name)
          }

          it { expect(response).to render_template(:edit) }

          subject(:resource) { assigns('organization') }

          it("should assign requested organization object") {
            expect(resource.id).to eql(organization.id)
          }
          it("should not update organization object") {
            expect(resource.reload.name).to_not eql(organization_name)
          }
        end

      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end

    describe "#destroy" do
      before(:each) { delete :destroy, id: organization.id }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to redirect_to(action: :index) }

        subject(:resource) { assigns('organization') }

        it("should assign requested organization object") { expect(resource.id).to eql(organization.id) }
        it("should destroy organization object") { expect(resource).to be_destroyed }
      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end
  end
end

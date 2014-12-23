require 'spec_helper'

describe RoomsController do
  xit 'have to be reimplemented' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:organization) { FactoryGirl.create(:organization) }
    let!(:member) {
      FactoryGirl.create(:member, {
        organization_id: organization.id,
        user_id: user.id,
        role_id: Role.owner.id
      })
    }

    let(:room_params) {
      FactoryGirl.attributes_for(:room).slice(:name)
    }

    let!(:rooms) {
      rooms = FactoryGirl.create_list(:room, 3, { organization_id: organization.id })
      rooms.each { |room| room.users << user }
      rooms
    }
    let(:room) {
      rooms.first
    }


    before(:each) { before_request rescue nil }

    describe "#index" do
      before(:each) { get :index, organization_id: organization.id }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to be_success }
        it { expect(response).to render_template(:index) }

        subject(:collection) { assigns('rooms') }

        it ("should assign rooms list") { expect(collection).to be }
        it ("should include allowed rooms in the list") {
          expect(collection.collect(&:id).sort).to eql(rooms.collect(&:id).sort)
        }

      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }
        it { expect(response).to redirect_to(root_url) }
      end

    end



    describe "#show" do
      before(:each) { get :show, organization_id: organization.id, id: room.id }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to be_success }
        it { expect(response).to render_template(:show)}

        subject(:resource) { assigns('room') }

        it ("should assign requested room object") {
          expect(resource).to eq(room)
        }
      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end

    end

    describe "#new" do
      before(:each) { get :new, organization_id: organization.id }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to be_success }
        it { expect(response).to render_template(:new)}

        subject(:resource) { assigns('room') }

        it("should assign new room object") {
          expect(resource).to be_new_record
        }
      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end

    end

    describe "#edit" do
      before(:each) { get :edit, organization_id: organization.id, id: room.id }
      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to be_success }
        it { expect(response).to render_template(:edit)}

        subject(:resource) { assigns('room') }

        it("should assign requested room object") {
          expect(resource).to eq(room)
        }
      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end

    describe "#create" do

      before(:each) {
        post :create, organization_id: organization.id, room: room_params
      }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        context "when valid room name provided" do

          subject(:resource) { assigns('room') }

          it("should assign room object") { expect(resource).to be_kind_of(Room) }
          it("should create room object") {
            expect(resource).to be_persisted
            expect(resource.reload.name).to eql(room_params[:name])
          }

          it {
            expect(response).to(redirect_to(chat_organization_room_path({
              organization_slug: organization.slug,
              room_slug: resource.slug})))
          }

        end

        context "when invalid room name provided" do
          let(:room_params) { super().merge({ name: ''}) }

          it { expect(response).to render_template(:new) }

          subject(:resource) { assigns('room') }

          it("should assign room object") { expect(resource).to be_kind_of(Room) }
          it("should not create room object") {
            expect(resource).not_to be_persisted
          }
        end

        context "when room name already exists in organization scope" do
          let(:before_request) {
            super()
            FactoryGirl.create(:room, name: room_params[:name], organization_id: organization.id)
          }

          it { expect(response).to render_template(:new) }

          subject(:resource) { assigns('room') }

          it("should assign room object") {
            expect(resource).to be_kind_of(Room)
          }
          it("should not create room object") {
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

      before(:each) {
        put :update, organization_id: organization.id, room: room_params.slice(:name), id: room.id
      }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        context "when valid room name provided" do
          it { expect(response).to redirect_to(action: :index) }

          subject(:resource) { assigns('room') }

          it("should assign requested room object") {
            expect(resource.id).to eql(room.id)
          }
          it("should update room object") {
             expect(resource.reload.name).to eq(room_params[:name])
          }
        end

        context "when invalid room name provided" do
          let(:room_params) { super().merge!({ name: ''}) }

          it { expect(response).to render_template(:edit) }

          subject(:resource) { assigns('room') }

          it("should assign requested room object") {
            expect(resource.id).to eql(room.id)
          }
          it("should not update room object") {
             expect(resource.reload.name).to_not eq(room_params[:name])
          }
        end

        context "when room name already exists in organization scope" do
          let(:room_params) { super().merge!({ name: rooms.last.name}) }

          it { expect(response).to render_template(:edit) }

          subject(:resource) { assigns('room') }

          it("should assign requested room object") {
            expect(resource.id).to eql(room.id)
          }
          it("should not update room object") {
             expect(resource.reload.name).to_not eq(room_params[:name])
          }
        end

      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end

    describe "#destroy" do
      before(:each) { delete :destroy, organization_id: organization.id, id: room.id }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        it { expect(response).to redirect_to(action: :index) }

        subject(:resource) { assigns('room') }

        it("should assign requested room object") { expect(resource.id).to eql(room.id) }
        it("should destroy room object") { expect(resource).to be_destroyed }
      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end

    describe "#leave" do
      before(:each) { delete :leave, organization_id: organization.id, id: room.id }

      context 'when user authenticated' do
        let(:before_request) { controller.auto_login(user) }

        subject(:resource) { assigns('room') }

        it("should assign requested room object") { expect(resource.id).to eql(room.id) }

        context "when 1 person in room" do

          it("should not destroy user's room membership") {
            expect(resource.reload.user_ids).to include(user.id)
          }

        end

        context "when more than 1 person in room" do
          let(:before_request) {
            super()
            room.users << FactoryGirl.create(:user)
          }

          it("should destroy user's room membership") {
            expect(resource.reload.user_ids).not_to include(user.id)
          }
          it { expect(response).to redirect_to(organization) }
        end

      end

      context 'when user is not authenticated' do
        let(:before_request) { controller.logout }

        it { expect(response).to redirect_to(root_url) }
      end
    end
  end
end

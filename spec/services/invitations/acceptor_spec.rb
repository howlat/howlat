require 'spec_helper'

describe Invitations::Acceptor do
  subject { described_class.new(valid_invitation, user) }

  let(:user) { FactoryGirl.create(:user) }
  let(:organization) { FactoryGirl.create(:organization) }
  let(:room) { FactoryGirl.create(:room, owner_id: organization.id) }
  let(:valid_invitation) { FactoryGirl.create(:invitation, room_id: room.id, email: user.email) }
  let(:invalid_invitation) { FactoryGirl.build(:invitation, room_id: nil) }

  it { expect(subject).to respond_to(:call).with(0).arguments }

  describe '#call' do
    subject { described_class.new(invitation, user) }

    context "when user is not a member of this room" do
      let(:invitation) { valid_invitation }
      before(:each) { subject.call }

      it("should create organization membership for user") {
        expect(user.organization_memberships.where(organization_id: organization.id).exists?).to be_true
      }
      it("should add user to room") {
        expect(user.room_memberships.where(room_id: invitation.room_id).exists?).to be_true
      }
      it("should destroy invitation") {
        expect(invitation).to be_destroyed
      }
      it("should destroy invitation with same email and room") {
        expect(Invitation.where(room_id: invitation.room_id, email: user.email).exists?).to be_false
      }
      it { expect(subject.call).to be_true }
    end


    context "when user is already a member of this room" do
      let(:invitation) { Invitation.where(email: user.email, room_id: room.id).first_or_create(false) }
      before(:each) { user.rooms << room }
      before(:each) { subject.call }

      it("should not add additional user membership to room") {
        expect(RoomMembership.where(user_id: user.id, room_id: room.id).count).to eql(1)
      }
      it("should destroy invitation") {
        expect(invitation).to be_destroyed
      }

      it { expect(subject.call).to be_true }
    end

    context "when invalid data provided" do
      let(:invitation) { invalid_invitation }
      before(:each) { subject.call }

      it("should not add additional user membership to room") {
        expect(!!RoomMembership.where(user_id: user.id, room_id: room.id).exists?).to be_false
      }

      it { expect(subject.call).to be_false }

    end
  end

end

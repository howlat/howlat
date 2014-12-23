require "spec_helper"

describe UserMailer do
  subject { UserMailer }
  let(:default_from) { 'notifications@howlat.me' }
  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe ".invitation_message" do
    before(:each) do
      subject.invitation_message(invited_by,invitation).deliver
    end

    let(:invited_by) { FactoryGirl.create(:user) }
    let(:invitation) {
      FactoryGirl.create(:invitation, {
        email: FactoryGirl.build(:user).email,
        room: FactoryGirl.create(:room, {
          owner: FactoryGirl.create(:organization)
          })
        })
    }
    let(:mail) { ActionMailer::Base.deliveries.first }

    it 'should send an email' do
      expect(ActionMailer::Base.deliveries.count).to eql(1)
    end
    it 'should set correct "to" field' do
      expect(mail.to).to eql([invitation.email])
    end
    it 'should set correct "subject" field' do
      expect(mail.subject).to eql("[Howlat] You have been invited to '#{invitation.room.name}' by #{invited_by.fullname}")
    end
    it 'should set correct "from" field' do
      expect(mail.from).to eql([default_from])
    end
  end

  describe ".invitation_canceled" do

    before(:each) do
      subject.invitation_canceled(invitation).deliver
    end

    let(:invitation) {
      FactoryGirl.create(:invitation, {
        email: FactoryGirl.build(:user).email,
        room: FactoryGirl.create(:room, {
          owner: FactoryGirl.create(:organization)
          })
        })
    }
    let(:mail) { ActionMailer::Base.deliveries.first }

    it 'should send an email' do
      expect(ActionMailer::Base.deliveries.count).to eql(1)
    end
    it 'should set correct "to" field' do
      expect(mail.to).to eql([invitation.email])
    end
    it 'should set correct "subject" field' do
      expect(mail.subject).to eql("[Howlat] Your invitation to '#{invitation.room.name}' has been canceled")
    end
    it 'should set correct "from" field' do
      expect(mail.from).to eql([default_from])
    end
  end

  describe ".remove_from_room" do
    before(:each) do
      subject.remove_from_room(user, room).deliver
    end

    let(:user) { FactoryGirl.create(:user) }
    let(:room) {
      r = FactoryGirl.create(:room, {
        owner: FactoryGirl.create(:organization),
        })
      r.members << user
      r
    }
    let(:mail) { ActionMailer::Base.deliveries.first }

    it 'should send an email' do
      expect(ActionMailer::Base.deliveries.count).to eql(1)
    end
    it 'should set correct "to" field' do
      expect(mail.to).to eql([user.email])
    end
    it 'should set correct "subject" field' do
      expect(mail.subject).to eql("[Howlat] You have been removed from '#{room.name}' room in #{room.owner.name}")
    end
    it 'should set correct "from" field' do
      expect(mail.from).to eql([default_from])
    end

  end

  describe ".remove_from_organization" do
    before(:each) do
      subject.remove_from_organization(membership, organization).deliver
    end

    let(:organization) { FactoryGirl.create(:organization) }
    let(:membership) {
      organization.memberships.create user_id: FactoryGirl.create(:user).id
    }
    let(:mail) { ActionMailer::Base.deliveries.first }

    it 'should send an email' do
      expect(ActionMailer::Base.deliveries.count).to eql(1)
    end
    it 'should set correct "to" field' do
      expect(mail.to).to eql([membership.user.email])
    end
    it 'should set correct "subject" field' do
      expect(mail.subject).to eql("[Howlat] You have been removed from #{organization.name} organization")
    end
    it 'should set correct "from" field' do
      expect(mail.from).to eql([default_from])
    end

  end

  describe ".reset_password_email" do
    before(:each) do
      user.reset_password_token = SecureRandom.hex
      subject.reset_password_email(user).deliver
    end

    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { ActionMailer::Base.deliveries.first }

    it 'should send an email' do
      expect(ActionMailer::Base.deliveries.count).to eql(1)
    end
    it 'should set correct "to" field' do
      expect(mail.to).to eql([user.email])
    end
    it 'should set correct "subject" field' do
      expect(mail.subject).to eql("[Howlat] Password Reset Instructions")
    end
    it 'should set correct "from" field' do
      expect(mail.from).to eql([default_from])
    end

  end

end

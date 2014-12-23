require 'spec_helper'

describe Invitation do
  let(:user) { FactoryGirl.create(:user) }
  let(:organization) { FactoryGirl.create(:organization) }
  let(:existing_object) { FactoryGirl.create(:invitation, {
    email: user.email,
    room_id: FactoryGirl.create(:room, {
      organization_id: organization.id
      }).id
    })
  }

  it { expect(subject).to respond_to :email }
  it { expect(subject).to respond_to :room }
  it { expect(subject).to respond_to :room_id }
  it { expect(subject).to respond_to :token }
  it { expect(subject).to respond_to :email= }
  it { expect(subject).to respond_to :room_id= }
  it { expect(subject).to respond_to :token= }

  it("should validate presence of email") {
    expect(subject).to have_at_least(1).errors_on(:email)
  }
  it("should validate format of email") {
    subject.email = 'this-is-not-an-email'
    expect(subject).to have(1).errors_on(:email)
  }
  it("should validate presence of room_id") {
    expect(subject).to have(1).errors_on(:room_id)
  }
  it("should generate token when not provided") {
    subject.token = nil
    expect(subject).to have(0).errors_on(:token)
    expect(subject).to_not be_blank
  }

end

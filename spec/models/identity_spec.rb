require 'spec_helper'

describe Identity do

  let(:existing_object) { FactoryGirl.create(:identity, {
    user_id: FactoryGirl.create(:user).id
    })
  }

  it { expect(subject).to respond_to :user }
  it { expect(subject).to respond_to :user_id }
  it { expect(subject).to respond_to :provider }
  it { expect(subject).to respond_to :uid }
  it { expect(subject).to respond_to :user_id= }
  it { expect(subject).to respond_to :provider= }
  it { expect(subject).to respond_to :uid= }

  it("should validate presence of provider") {
    expect(subject).to have_at_least(1).errors_on(:provider)
  }

  it("should validate inclusion of provider") {
    subject.provider = 'unsupported-provider'
    expect(subject).to have_at_least(1).errors_on(:provider)
  }

  it("should validate presence of uid") {
    expect(subject).to have(1).errors_on(:uid)
  }
  it("should validate presence of user_id") {
    expect(subject).to have(1).errors_on(:user_id)
  }
  it("should validate uniqueness of uid in provider's scope") {
    subject.uid = existing_object.uid
    subject.provider = existing_object.provider
    expect(subject).to have(1).errors_on(:uid)
  }

  describe "Identity::PROVIDERS" do
    subject { described_class::PROVIDERS }
    it { expect(subject).to be_present }
    it { expect(subject).to include('bitbucket', 'github') }
  end
end

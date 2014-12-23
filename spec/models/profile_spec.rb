require 'spec_helper'

describe Profile do

  let(:persisted_subject) { FactoryGirl.create(:user, :with_identities).profile }

  it { should respond_to :fullname }
  it { should respond_to :full_name }
  it { should respond_to :name }
  it { should respond_to :url }
  it { should respond_to :website }
  it { should respond_to :reset_avatar= }

  it { should belong_to :account }
  it { should belong_to :avatar_provider }

  it { expect(persisted_subject).to(
    ensure_inclusion_of(:avatar_provider_id)
    .in_array(persisted_subject.account.identity_ids))
  }

  describe "#reset_avatar=" do
    before(:each) { subject.reset_avatar = 1 }
    it("should clear avatar") { expect(subject.avatar).to be_blank }
  end
end

require 'spec_helper'

describe Room do

  it_behaves_like "models/concerns/api_keyable"
  it_behaves_like "models/concerns/sluggable"

  it { expect(subject).to respond_to :owner_id }
  it { expect(subject).to respond_to :name }
  it { expect(subject).to respond_to :slug }
  it { expect(subject).to respond_to :access }
  it { expect(subject).to respond_to :access_policy }
  it { expect(subject).to respond_to :updated_at }
  it { expect(subject).to respond_to :created_at }
  it { expect(subject).to respond_to :jid }
  it { expect(subject).to respond_to :public? }
  it { expect(subject).to respond_to :private? }
  it { expect(subject).to respond_to :integrations }
  it { expect(subject).to respond_to :badge }

  it('should enumerate access') {
    should enumerize(:access).in(*described_class.access.values)
  }
  it('should enumerate access_policy') {
    should enumerize(:access_policy).in(*described_class.access_policy.values)
  }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:owner_id) }
  it { should allow_value('madglory/parleychat.com', 'mad-tsh/parley').for(:name) }
  it { should_not allow_value('--madglory', '__madglory', 'madglory.').for(:name) }
  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug).scoped_to(:owner_id) }

  it { should validate_presence_of(:access) }
  it { should ensure_inclusion_of(:access).in_array(described_class.access.values) }
  it { should ensure_inclusion_of(:access_policy).in_array(described_class.access_policy.values).allow_nil }

  it { should belong_to :owner }
  it { should have_many(:memberships) }
  it { should have_many(:members).through(:memberships) }
  it { should have_many(:invitations) }
  it { should have_many(:messages) }
  it { should have_many(:threads) }
  it { should have_many(:tags).through(:messages) }
  it { should have_one(:api_key).class_name("RoomApiKey") }
  it { should have_one(:repository) }

  describe '#jid' do
    before(:each) { subject.slug = 'room-slug' }
    it "should return correct jid" do
      expect(subject.jid).to be_eql("room-slug@conference.#{ENV['XMPP_DOMAIN']}")
    end
  end

  describe '#badge' do
    it { expect(subject.badge).to be_kind_of(Badge) }
  end

end

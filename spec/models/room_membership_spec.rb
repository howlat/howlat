require 'spec_helper'

describe RoomMembership do
  let!(:persisted_subject) { FactoryGirl.create(:room_membership) }

  it { expect(subject).to respond_to :user_id }
  it { expect(subject).to respond_to :room_id }
  it { expect(subject).to respond_to :room_hidden }

  it { expect(subject).to validate_presence_of(:room_id) }
  it { expect(subject).to validate_presence_of(:user_id) }
  it { expect(persisted_subject).to validate_uniqueness_of(:user_id).scoped_to(:room_id) }

  it { should belong_to :user }
  it { should belong_to :room }

end

require 'spec_helper'

describe Tagging do

  let(:persisted_subject) { FactoryGirl.create(:tagging) }

  it { expect(subject).to respond_to :message_id }
  it { expect(subject).to respond_to :tag_id }

  it { should(validate_presence_of(:message_id)) }
  it { should validate_presence_of(:tag_id) }
  it { expect(persisted_subject).to validate_uniqueness_of(:tag_id).scoped_to(:message_id) }

  it { should belong_to :message }
  it { should belong_to :tag }

end

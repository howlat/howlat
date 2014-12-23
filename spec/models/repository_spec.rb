require 'spec_helper'

describe Repository do

  it { should belong_to :room }

  it { should validate_presence_of(:room_id) }
  it { should validate_uniqueness_of(:room_id) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe '#connected?' do
    context 'when connected with 3rd party via hook' do
      before(:each) { subject.hook_id = 1000 }
      it { expect(subject.connected?).to be_true }
    end

    context 'when not connected with 3rd party via hook' do
      before(:each) { subject.hook_id = nil }
      it { expect(subject.connected?).to be_false }
    end
  end
end

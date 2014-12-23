require 'spec_helper'

describe Preferences do

  it { should enumerize(:audio_notification)
    .in(*described_class.audio_notification.values).with_default(:mentions)
  }
  it { should enumerize(:desktop_notification)
    .in(*described_class.desktop_notification.values).with_default(:mentions)
  }

  it { should belong_to(:user) }

  it { should validate_presence_of(:user_id) }
  it { should validate_uniqueness_of(:user_id) }
  it "should only allow integers from 0 to 100" do
    should validate_numericality_of(:audio_volume)
    .only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100)
  end

end

require 'spec_helper'

describe ChatMessage do

  it { should validate_presence_of :author_id }
  it { should validate_presence_of :body }

end

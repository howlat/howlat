require 'spec_helper'

describe Tag do
  it_behaves_like 'models/concerns/inheritable/sti'
  it_behaves_like 'models/tag'
end

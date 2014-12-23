require 'spec_helper'

describe Organization do

  it_behaves_like 'models/account'

  it { should have_many(:members).through(:memberships) }
  it { should have_many(:memberships) }

end

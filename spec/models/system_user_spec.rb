require 'spec_helper'

describe SystemUser do

  it { should respond_to :id }
  it { should respond_to :profile }
  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :jid }
  it { should respond_to :last_activity_at }
  it { should respond_to :updated_at }

  it_behaves_like 'models/concerns/profilable'

end

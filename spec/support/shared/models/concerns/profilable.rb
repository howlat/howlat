shared_examples "models/concerns/profilable" do

  it { should respond_to :fullname }
  it { should respond_to :display_name }
  it { should respond_to :avatar_url }
  if ancestors.include?(::ActiveRecord::Base)
    it { should have_one :profile }
    it { should accept_nested_attributes_for(:profile) }
  end

end

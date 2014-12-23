shared_examples "models/concerns/api_keyable" do

  it { should have_one :api_key }
  it { should respond_to :token }

end

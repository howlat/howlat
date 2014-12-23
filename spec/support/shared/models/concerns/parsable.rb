shared_examples "models/concerns/parsable" do

  it "should respond to .parsers" do
    expect(described_class).to respond_to(:parsers)
  end

end

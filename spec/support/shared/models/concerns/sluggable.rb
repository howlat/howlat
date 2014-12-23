shared_examples "models/concerns/sluggable" do

  describe "#generate_slug" do
    before(:each) do
      subject.name = "awesome-thing@świętochłowice"
      subject.slug = nil
      subject.save
    end
    it "should generate correct slug" do
      expect(subject.slug).to eq("awesome-thing-at-swietochlowice")
    end
  end

end

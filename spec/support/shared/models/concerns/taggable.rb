shared_examples "models/concerns/taggable" do

  it { should have_many :taggings }
  it { should have_many(:tags).through(:taggings) }
  it { should respond_to :tag_list }
  it { should respond_to :stringified_tag_ids }
  it { should respond_to :cached_tag_list }
  it { should respond_to :cache_tag_list }
  it { should respond_to :cache_tag_list_key }

  describe '#tags' do
    it { expect(subject.tags).to respond_to(:add).with(1).argument }
    it { expect(subject.tags).to respond_to(:remove).with(1).argument }
  end

  describe '.tagged_with' do
     it { expect(described_class).to respond_to(:tagged_with).with(1).argument }
  end
end

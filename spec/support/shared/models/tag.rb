shared_examples "models/tag" do

  let(:tag) {
    factory_name = described_class.name.underscore
    FactoryGirl.create(factory_name)
  }

  it { should respond_to :name }

  it { should validate_presence_of(:name) }
  it { expect(tag).to validate_uniqueness_of(:name) }

  it { should have_many(:messages).through(:taggings) }
  it { should have_many(:taggings) }

end

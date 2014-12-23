shared_examples "models/account" do

  let(:account) {
    FactoryGirl.create(described_class.name.underscore.to_sym)
  }

  it_behaves_like 'models/concerns/profilable'

  it { should respond_to :name }
  it { should respond_to :email }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { expect(account).to validate_uniqueness_of(:name) }
  it { expect(account).to validate_uniqueness_of(:email) }
  it { should     allow_value("test@email.com").for(:email) }
  it { should_not allow_value("test-email.com").for(:email) }

end

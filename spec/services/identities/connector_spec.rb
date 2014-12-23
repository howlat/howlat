require 'spec_helper'

describe Identities::Connector do

  it { expect(subject).to respond_to(:call).with(2).arguments }

  describe('#call(user, identity_params)') do
    before(:each) { @result = subject.call(user, identity_params) }

    context "with valid arguments" do
      let(:user) { FactoryGirl.create(:user) }
      let(:identity_params) { FactoryGirl.attributes_for(:valid_oauth) }
      it("should assign identity instance variable") {
        expect(subject.instance_variable_get(:@identity)).to be_kind_of(Identity)
      }
      it { expect(@result).to be_true }
    end

    context "with invalid user object" do
      let(:user) { nil }
      let(:identity_params) { FactoryGirl.attributes_for(:valid_oauth) }
      it("should assign identity instance variable") {
        expect(subject.instance_variable_get(:@identity)).to be_nil
      }
      it { expect(@result).to be_false }
    end

    context "with invalid identity attributes" do
      let(:user) { FactoryGirl.create(:user) }
      let(:identity_params) { FactoryGirl.attributes_for(:valid_oauth).slice(:provider) }
      it("should assign identity instance variable") {
        expect(subject.instance_variable_get(:@identity)).to be_kind_of(Identity)
      }
      it { expect(@result).to be_false }
    end

  end

end

require 'spec_helper'

describe Registration::Strategies::Form do
  let(:user_class) { User }

  subject { Registration::Strategies::Form.new(user_class) }

  it { expect(subject).to respond_to(:register).with(1).argument }
  it { expect(subject).to respond_to(:user) }

  describe('#register(registration_params)') do

    before(:each) { @result = subject.register(data) }

    context "when valid data provided" do
      let(:data) { FactoryGirl.attributes_for(:user).slice(:name, :email, :password) }

      it("should register user") {
        expect(!!user_class.where(email: data[:email]).exists?).to be_true
      }
      it("should assign user instance variable") {
        expect(subject.instance_variable_get(:@user)).to be_kind_of(user_class)
      }
      it { expect(@result).to be_true }
    end

    context "when invalid data provided" do
      let(:data) { FactoryGirl.attributes_for(:user).slice(:email) }

      it("should not register user") {
        expect(!!user_class.where(email: data[:email]).exists?).to be_false
      }
      it("should assign user instance variable") {
        expect(subject.instance_variable_get(:@user)).to be_kind_of(user_class)
      }
      it { expect(@result).to be_false }
    end

  end

end

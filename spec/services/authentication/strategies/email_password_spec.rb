require 'spec_helper'

describe Authentication::Strategies::EmailPassword do
  let(:user_class) { User }
  let(:api_key_class) { ApiKey }

  subject { Authentication::Strategies::EmailPassword.new(user_class, api_key_class) }

  it { expect(subject).to respond_to(:authenticate).with(1).argument }

  describe('#authenticate(credentials)') do

    before(:each) { @result = subject.authenticate(credentials) }

    context "when valid credentials provided" do
      let(:user) { FactoryGirl.create(:user, password: '12345678') }
      let(:credentials) {
        { email: user.email, password: '12345678' }
      }

      it("should be authenticated user") { expect(@result).to be_eql(user) }
    end

    context "when invalid credentials provided" do
      let(:credentials) { FactoryGirl.attributes_for(:user).slice(:email) }

      it { expect(@result).to be_nil }
    end

  end

end

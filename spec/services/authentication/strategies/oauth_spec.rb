require 'spec_helper'

describe Authentication::Strategies::Oauth do
  let(:user_class) { User }
  let(:api_key_class) { ApiKey }

  subject { Authentication::Strategies::Oauth.new(user_class, api_key_class) }

  it { expect(subject).to respond_to(:authenticate).with(1).argument }

  describe('#authenticate(credentials)') do

    before(:each) { @result = subject.authenticate(credentials) }

    context "when valid credentials provided" do
      let(:user) { FactoryGirl.create(:user) }
      let(:identity) { FactoryGirl.create(:identity, user_id: user.id) }
      let(:credentials) {
        { uid: identity.uid, provider: identity.provider }
      }

      it("should be authenticated user") { expect(@result).to eql(user) }
    end

    context "when invalid credentials provided" do
      let(:credentials) { FactoryGirl.attributes_for(:identity) }

      it { expect(@result).to be_nil }
    end

  end

end

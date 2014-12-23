require 'spec_helper'

describe Authentication::Service do

  it { expect(subject).to respond_to(:call).with(1).argument }

  describe('#initialize(strategy, user_class)') do
    subject { Authentication::Service.new(strategy) }

    context "when known strategy requested" do
      let(:strategy) { :email_password }
      it("should assign that strategy object") {
        expect(subject.instance_variable_get(:@strategy)).to be_kind_of(Authentication::Strategies::EmailPassword)
      }
    end

    context "when unknown strategy requested" do
      let(:strategy) { :unknown_strategy }
      it("should fallback to EmailPassword strategy") {
        expect(subject.instance_variable_get(:@strategy)).to be_kind_of(Authentication::Strategies::EmailPassword)
      }
    end

  end

end

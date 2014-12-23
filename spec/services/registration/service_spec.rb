require 'spec_helper'

describe Registration::Service do

  it { expect(subject).to respond_to(:call).with(1).argument }
  it { expect(subject).to respond_to(:user) }

  describe('#initialize(strategy, user_class)') do
    subject { Registration::Service.new(strategy) }

    context "when known strategy requested" do
      let(:strategy) { :form }
      it("should assign that strategy object") {
        expect(subject.instance_variable_get(:@strategy)).to be_kind_of(Registration::Strategies::Form)
      }
    end

    context "when unknown strategy requested" do
      let(:strategy) { :unknown_strategy }
      it("should fallback to Form strategy") {
        expect(subject.instance_variable_get(:@strategy)).to be_kind_of(Registration::Strategies::Form)
      }
    end

  end

end

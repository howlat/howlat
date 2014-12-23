require 'spec_helper'

describe Registration::Strategies::Base do
  let(:user_class) { User }

  subject { Registration::Strategies::Base.new(user_class) }

  it { expect(subject).to respond_to(:register).with(1).argument }
  it { expect(subject).to respond_to(:user) }

  describe('#register(registration_params)') do

    let(:data) { FactoryGirl.attributes_for(:user).slice(:name, :email, :password) }

    it { expect{subject.register(data)}.to raise_error(NotImplementedError) }

  end

end

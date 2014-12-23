require 'spec_helper'

describe Authentication::Strategies::Base do
  let(:user_class) { User }
  let(:api_key_class) { ApiKey }
  subject { Authentication::Strategies::Base.new(user_class, api_key_class) }

  it { expect(subject).to respond_to(:authenticate).with(1).argument }

  describe('#authenticate(credentials)') do

    let(:credentials) {
      { email: 'email@email.com', password: '12345678' }
    }

    it { expect{subject.authenticate(credentials)}.to raise_error(NotImplementedError) }

  end

end

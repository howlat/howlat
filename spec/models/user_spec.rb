require 'spec_helper'

describe User do

  let(:persisted_subject) { FactoryGirl.create(:user) }

  it_behaves_like 'models/account'
  it_behaves_like 'models/concerns/api_keyable'

  it { should have_one(:api_key).class_name("PersonalApiKey") }

  describe '#jid' do
    it "should return correct jid" do
      u = persisted_subject
      expected_jid = "#{u.id}.#{u.name}@#{ENV['XMPP_DOMAIN']}"
      expect(u.jid).to be_eql(expected_jid)
    end
  end

end

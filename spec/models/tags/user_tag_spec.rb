require 'spec_helper'

describe Tags::UserTag do

  it_behaves_like "models/tag"

  it { should respond_to :user_id }
  it { should respond_to :username }
  it { should respond_to :user }
  it { should respond_to :everyone? }

  let(:everyone_mention) {
    FactoryGirl.build('tags/user_tag', :everyone_tag)
  }
  let(:single_mention) { FactoryGirl.build('tags/user_tag') }

  context "when everyone mention" do
    it("should recognize it as everyone mention") {
      expect(everyone_mention.everyone?).to be_true
    }
    describe '#to_label' do
      it { expect(everyone_mention.to_label).to be_eql('@everyone') }
    end

    describe '#user_id' do
      it { expect(everyone_mention.user_id).to be_eql('everyone') }
    end

    describe '#user' do
      it { expect(everyone_mention.user).to be_eql('everyone') }
    end

    describe '#username' do
      it { expect(everyone_mention.username).to be_eql('everyone') }
    end

  end

  context "when single mention" do
    it("should not recognize it as everyone mention") {
      expect(single_mention.everyone?).to be_false
    }
  end

end

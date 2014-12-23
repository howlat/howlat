require 'spec_helper'

describe ApplicationHelper do
  subject { helper }

  describe "#avatar_for" do
    context "when user has avatar set" do
      let(:user) { FactoryGirl.create(:user, :with_avatar)}
      let(:profile) { user.profile }
      let(:size) { :thumb }
      it { expect(subject.avatar_for(profile, size).to_s).to include(CGI.escapeHTML(profile.avatar.url(size))) }
    end
    context "when user does not have avatar set" do
      let(:user) { FactoryGirl.create(:user) }
      let(:profile) { user.profile }
      it { expect(subject.avatar_for(profile).to_s).to include(CGI.escapeHTML(subject.gravatar_url_for(profile.email))) }
    end
  end

  describe "#height_for" do
    context "when no size" do
      let(:size) { nil }
      it { expect(subject.height_for(size)).to eql(40) }
    end
    context "when size is small" do
      let(:size) { :small }
      it { expect(subject.height_for(size)).to eql(75) }
    end
    context "when no size medium" do
      let(:size) { :medium }
      it { expect(subject.height_for(size)).to eql(150) }
    end
  end

  describe "#width_for" do
    context "when no size" do
      let(:size) { nil }
      it { expect(subject.width_for(size)).to eql(40) }
    end
    context "when size is small" do
      let(:size) { :small }
      it { expect(subject.width_for(size)).to eql(75) }
    end
    context "when no size medium" do
      let(:size) { :medium }
      it { expect(subject.width_for(size)).to eql(150) }
    end
  end

  describe "#gravatar_url_for" do
    context "when user is john.kovalsky@gmail.com" do
      let(:user) { FactoryGirl.create(:user, email: 'john.kovalsky@gmail.com') }
      let(:email_digest) { Digest::MD5.hexdigest(user.email) }
      it { expect(subject.gravatar_url_for(user.email)).to eql("http://www.gravatar.com/avatar/#{email_digest}.png?d=mm&s=40") }
    end
  end
end

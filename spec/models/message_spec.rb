require 'spec_helper'

describe Message do

  let(:room) { FactoryGirl.build(:room) }
  let(:persisted_room) { FactoryGirl.create(:room) }

  it { should respond_to :author }
  it { should respond_to :author_id }
  it { should respond_to :body }
  it { should respond_to :updated_at }
  it { should respond_to :created_at }
  it { should respond_to :parameters }
  it { should respond_to :attachment_file_name }
  it { should respond_to :attachment_content_type }
  it { should respond_to :attachment_file_size }
  it { should respond_to :attachment_updated_at }
  it { should respond_to :attachment_url }
  it { should respond_to :updated_at }
  it { should respond_to :created_at }

  it { should validate_presence_of :room_id }

  it { should belong_to :author }
  it { should belong_to :parent }
  it { should belong_to :room }

  it_behaves_like "models/concerns/inheritable/sti"
  it_behaves_like "models/concerns/taggable"
  it_behaves_like "models/concerns/parsable"

  describe "#attachment_url" do
    context "when attachment provided" do
      subject { FactoryGirl.build(:message_with_attachment, room_id: room.id) }
      it { expect(subject.attachment_url).to eql(subject.attachment.url) }
    end
    context "when attachment not provided" do
      subject { FactoryGirl.build(:message, room_id: room.id) }
      it { expect(subject.attachment_url).to be_blank }
    end
  end

  context "when attachment provided" do
    subject { FactoryGirl.create(:message_with_attachment, room_id: persisted_room.id) }
    it("should update body to attachment_url") do
      expect(subject.body).to eql(subject.attachment_url)
    end
  end

  describe "parsers" do
    let(:user) do
      user = FactoryGirl.create(:user)
      persisted_room.members << user
      user
    end
    let(:message_with_tags) {
      FactoryGirl.create(:message, room_id: persisted_room.id, body: "#tag @#{user.name}")
    }

    it "should found tags in message's body" do
      expect(message_with_tags).to have_exactly(2).tags
    end

  end

end

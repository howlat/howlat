# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :message do
    sequence(:body) {|n| "Message Body #{n}" }
    room
    parent nil
    association :author, factory: :user
    type 'chat'

    trait :with_attachment do
      attachment {
        fixture_file_upload Rails.root.join('spec', 'files', 'chickenback.jpg'), 'image/jpg'
      }
    end

    factory :message_with_attachment, traits: [:with_attachment]

  end
end

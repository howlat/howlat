# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    account nil
    name "MyString"
    email "MyString"
    location "MyString"
    company "MyString"
    website "MyString"

    trait :with_avatar do
      avatar {
        fixture_file_upload Rails.root.join('spec', 'files', 'chickenback.jpg'), 'image/jpg'
      }
    end
    factory :profile_with_avatar, traits: [:with_avatar]
  end
end

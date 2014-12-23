# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.com" }
    sequence(:name) { |n| "user-#{n}" }
    sequence(:password) { |n| "user-#{n}-password" }
    profile
    trait :with_identities do
      after(:create) do |u|
        create_list :identity, 2, user: u
      end
    end

    trait :with_avatar do
      profile { FactoryGirl.create :profile_with_avatar }
    end
  end
end

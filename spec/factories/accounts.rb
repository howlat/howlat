# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    sequence(:email) { |n| "user-#{n}@example.com" }
    sequence(:name) { |n| "user-#{n}" }
    profile
  end
end

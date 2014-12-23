# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    sequence(:name) {|n| "Organization-#{n}" }
    sequence(:email) { |n| "organization-#{n}@example.com" }
    profile
  end
end

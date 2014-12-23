# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :room do
    sequence(:name) {|n| "owner-#{n}/room-#{n}" }
    slug nil
    owner_id nil
    access 'public'
    access_policy nil
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity do
    user
    provider { Identity::PROVIDERS.sample }
    uid { SecureRandom.hex(16) }
    first_name nil
    last_name nil
    avatar nil
    email nil
    nickname nil
    name nil
  end
end
